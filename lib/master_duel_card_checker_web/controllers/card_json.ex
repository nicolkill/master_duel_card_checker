defmodule MasterDuelCardCheckerWeb.CardJSON do
  alias MasterDuelCardChecker.CardDatabase.Card

  @doc """
  Renders a list of cards.
  """
  def index(%{cards: cards}) do
    %{data: for(card <- cards, do: data(card))}
  end

  def index(%{boosters: boosters}) do
    %{data: for(booster <- boosters, do: data(booster))}
  end

  @doc """
  Renders a single card.
  """
  def show(%{card: card}) do
    %{data: data(card)}
  end

  def show(%{booster: booster}) do
    %{data: data(booster)}
  end

  def generate_image(%{"external_id" => external_id}) do
    "https://s3.duellinksmeta.com/cards/#{external_id}_w420.webp"
  end

  defp data(%Card{} = card) do
    %{
      id: card.id,
      name: card.name,
      ycg_booster: card.ycg_booster,
      mdm_data: Map.drop(card.mdm_data, ["__struct__", "external_id", "game_id", "image_hash"]),
      ycg_data: Map.drop(card.ycg_data, ["__struct__"]),
      card_image: generate_image(card.mdm_data),
      master_duel_released: !is_nil(card.mdm_data) and !is_nil(card.mdm_data["rarity"])
    }
  end

  defp data(booster) do
    %{
      id: booster.id,
      index: booster.index,
      name: booster.name
    }
  end
end
