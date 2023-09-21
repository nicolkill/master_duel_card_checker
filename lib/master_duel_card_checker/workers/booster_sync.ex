defmodule MasterDuelCardChecker.Workers.BoosterSync do
  use Oban.Worker

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.CardDatabase.Card
  alias MasterDuelCardChecker.Integrations.MasterDuelMeta
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card, as: YugiohCardGuideCard

  defp process_card(mdm_cards, ycg_card, transaction) do
    mdm_card = Enum.find(mdm_cards, &(&1.name == ycg_card.name))
    card = CardDatabase.get_card_by_name(ycg_card.name)

    card =
      case card do
        %Card{mdm_data: %{"rarity" => rarity}} when not is_nil(rarity) ->
          transaction
        card ->
          card =
            CardDatabase.change_card(card, %{
              ycg_booster: Enum.dedup(card.ycg_booster ++ ycg_card.release_packs),
              ycg_data: ycg_card,
              mdm_data: mdm_card
            })

          Ecto.Multi.insert_or_update(
            transaction,
            "upsert_#{ycg_card.name}",
            card
          )
      end
  end

  @impl Oban.Worker
  def perform(%{args: %{"booster_id" => booster_id}}) do
    result =
      booster_id
      |> YugiohCardGuide.list_cards()
      |> Enum.chunk_every(25)
      |> Enum.map(fn ycg_cards ->
        mdm_cards =
          ycg_cards
          |> Enum.map(fn %YugiohCardGuideCard{name: name} ->
            name
          end)
          |> Enum.join("|")
          |> MasterDuelMeta.list_cards()

        {:ok, data} =
          ycg_cards
          |> Enum.reduce(Ecto.Multi.new(), &process_card(mdm_cards, &1, &2))
          |> MasterDuelCardChecker.Repo.transaction()

        data
        |> Map.keys()
        |> length()
      end)

    {:ok, result}
    #  rescue
    #    e ->
    #      IO.inspect(e, label: "booster sync error")
    #
    #      {:snooze, 10}
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  def enqueue_job(booster_id, delay) do
    %{booster_id: booster_id}
    |> new(max_attempts: 5, schedule_in: delay)
    |> Oban.insert()
  end
end
