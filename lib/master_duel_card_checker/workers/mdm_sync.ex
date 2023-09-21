defmodule MasterDuelCardChecker.Workers.MdmSync do
  use Oban.Worker

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.CardDatabase.Card
  alias MasterDuelCardChecker.Integrations.MasterDuelMeta

  defp process_card(mdm_cards, %Card{} = card, transaction) do
    mdm_card = Enum.find(mdm_cards, &(&1.name == card.name))

    case card do
      %Card{mdm_data: %{"rarity" => rarity}} when not is_nil(rarity) ->
        transaction
      card ->
        card_changeset =
          CardDatabase.change_card(card, %{
            mdm_data: mdm_card
          })

        Ecto.Multi.insert_or_update(
          transaction,
          "update_#{card.name}",
          card_changeset
        )
    end
  end

  @impl Oban.Worker
  def perform(%{args: %{"page" => page}}) do
    size = 100

    cards = CardDatabase.list_cards_by_not_sync(page)

    mdm_cards =
      cards
      |> Enum.map(&String.replace(&1.name, " - ", " – "))
      |> Enum.join("|")
      |> MasterDuelMeta.list_cards()

    {:ok, data} =
      cards
      |> Enum.reduce(Ecto.Multi.new(), &process_card(mdm_cards, &1, &2))
      |> MasterDuelCardChecker.Repo.transaction()


    if length(cards) == size do
      start_job(page + 1)
    end

    :ok
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(60 * 2)

  def start_job(page \\ 0) do
    %{page: page}
    |> new()
    |> Oban.insert()
  end
end
