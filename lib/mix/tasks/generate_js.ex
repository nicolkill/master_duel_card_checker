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
  defp delete_save(file_path, content) do
    :ok = File.write(file_path, content)
  end
  
  defp save_start(file_path) do
    content = """
    const DATA = [
    """
    :ok = delete_save(file_path, content)
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

  defp normalize_name(name),
       do: name
           |> String.replace("-", "_")

  defp generate_path(file_name) do
    :master_duel_card_checker
    |> :code.priv_dir()
    |> (&"#{&1}/generated/#{file_name}.js").()
  end

  @shortdoc "Generates the file .js file with the cards data."
  def run(_) do
    Mix.Task.run("app.start")

    boosters =
      YugiohCardGuide.get_booster_packs()

    Enum.each(boosters, fn booster ->
      booster_name = normalize_name("booster_#{booster.id}")
      file_path = generate_path(booster_name)
      save_start(file_path)

      cards =
        file_path
        |> process_booster(booster.id)
        |> Enum.map(fn card ->
          Map.merge(card, %{
            card_image: CardJSON.generate_image(card),
            master_duel_released: !is_nil(card.mdm_data) and !is_nil(card.mdm_data["rarity"])
          })
        end)
      booster = Map.put(booster, :cards, cards)
      save_chunk(file_path, Jason.encode!(booster))
      save_end(file_path)
    end)


    master_file_path = generate_path("index")

    delete_save(master_file_path, "// file start\n")
    Enum.each(boosters, fn booster ->
      booster_name = normalize_name("booster_#{booster.id}")
      save_chunk(master_file_path, "import #{booster_name} from \"./#{booster_name}\";\n")
    end)
    save_chunk(master_file_path, "const DATA = []\n")
    Enum.each(boosters, fn booster ->
      booster_name = normalize_name("booster_#{booster.id}")
      save_chunk(master_file_path, "  .concat(#{booster_name})\n")
    end)
    save_chunk(master_file_path, ";\n\nexport default DATA\n")
  end
end