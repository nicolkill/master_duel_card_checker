defmodule MasterDuelCardChecker.Integrations.MasterDuelMeta.Card do

  alias MasterDuelCardChecker.Integrations.MasterDuelMeta.Card

  @keys [
    :game_id,
    :external_id,
    :image_hash,
    :konami_id,
    :name,
    :type,
    :race,
    :description,
    :ocg_release
  ]
  @rarity_keys [
    :rarity,
    :release,
    :release_packs,
    :ban_status
  ]
  @monster_keys [
    :level,
    :attribute,
    :atk,
    :def
  ]
  @enforce_keys []
  defstruct @keys ++ @rarity_keys ++ @monster_keys ++ @enforce_keys

  def parse(data) do
    general_data = parse_general(data)
    rarity_data = parse_rarity(data)
    type_data = parse_type(data)

    general_data
    |> Map.merge(rarity_data)
    |> Map.merge(type_data)
    |> then(&struct(Card, &1))
  end

  defp optional_fields(data, fields), do: Enum.reduce(fields, %{}, &Map.put(&2, &1, Map.get(data, &1)))

  defp parse_general(data) do
    %{
      "_id" => external_id,
      "name" => name,
      "type" => type,
      "race" => race,
      "description" => description
    } = data

    %{
      "gameId" => game_id,
      "konamiID" => konami_id,
      "imageHash" => image_hash,
      "ocgRelease" => ocg_release,
      "monsterType" => monster_type
    } = optional_fields(data, ["gameId", "konamiID", "imageHash", "ocgRelease", "monsterType"])

    %{
      game_id: game_id,
      external_id: external_id,
      image_hash: image_hash,
      konami_id: konami_id,
      name: name,
      type: Enum.join([type] ++ monster_type, " "),
      race: race,
      description: description,
      ocg_release: ocg_release
    }
  end

  defp parse_rarity(%{"rarity" => rarity} = data) do
    %{
      "release" => release,
      "obtain" => release_packs,
    } = data

    %{
      "banStatus" => ban_status
    } = optional_fields(data, ["banStatus"])

    %{
      rarity: rarity,
      release: release,
      release_packs: Enum.map(release_packs, &get_in(&1, ["source", "name"])),
      ban_status: ban_status
    }
  end
  defp parse_rarity(_), do: %{}

  defp parse_type(%{"type" => "Monster"} = data) do
    %{
      "attribute" => attribute,
      "atk" => atk,
      "def" => def,
    } = data

    %{
      "level" => level,
      "scale" => scale
    } = optional_fields(data, ["level", "scale"])

    %{
      level: level,
      attribute: attribute,
      atk: atk,
      def: def
    }
  end
  defp parse_type(_), do: %{}

end
