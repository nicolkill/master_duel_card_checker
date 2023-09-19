defmodule MasterDuelCardCheckerWeb.CardJSON do
  alias MasterDuelCardChecker.CardDatabase.Card

  @doc """
  Renders a list of cards.
  """
  def index(%{cards: cards}) do
    %{data: for(card <- cards, do: data(card))}
  end

  @doc """
  Renders a single card.
  """
  def show(%{card: card}) do
    %{data: data(card)}
  end

  defp generate_image(%{"external_id" => external_id}) do
    "https://s3.duellinksmeta.com/cards/#{external_id}_w420.webp"
  end

  defp data(%Card{} = card) do
    %{
      id: card.id,
      mdm_data: card.mdm_data,
      ycg_data: card.ycg_data,
      ycg_booster: card.ycg_booster,
      card_image: generate_image(card.mdm_data)
    }
  end
end
