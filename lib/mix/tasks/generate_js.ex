defmodule Mix.Tasks.GenerateJs do
  @moduledoc "Generates the .js file with all the data of the yugioh cards"
  use Mix.Task

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide
  alias MasterDuelCardCheckerWeb.CardJSON

  # file write funcs
  defp save_chunk(file_path, content) do
    :ok = File.write(file_path, content, [:append])
  end
  
  defp save_start(file_path) do
    content = """
    const DATA = [
    """
    :ok = File.write(file_path, content)
  end
  
  defp save_end(file_path) do
    content = """
    ];

    export default DATA;
    """
    save_chunk(file_path, content)
  end
  
  # database iteration funcs
  defp process_booster(path, booster_id, page \\ 0) do
    size = 100
    data = CardDatabase.list_cards_by_booster(booster_id, page)
    if length(data) == size,
       do: data ++ process_booster(path, booster_id, page + 1),
       else: data
  end

  @shortdoc "Generates the file .js file with the cards data."
  def run(_) do
    Mix.Task.run("app.start")

    file_path =
      :master_duel_card_checker
      |> :code.priv_dir()
      |> (&"#{&1}/data_source.js").()

    save_start(file_path)

    YugiohCardGuide.get_booster_packs()
    |> Enum.each(fn booster ->
      cards =
        file_path
        |> process_booster(booster.id)
        |> Enum.map(fn card ->
          Map.merge(card, %{
            card_image: CardJSON.generate_image(card.mdm_data),
            master_duel_released: !is_nil(card.mdm_data) and !is_nil(card.mdm_data["rarity"])
          })
        end)
      booster = Map.put(booster, :cards, cards)
      save_chunk(file_path, Jason.encode!(booster) <> ",")
    end)

    save_end(file_path)
  end
end