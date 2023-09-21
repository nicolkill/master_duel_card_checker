defmodule MasterDuelCardChecker.Integrations.YugiohCardGuide.Card do
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card

  @keys [
    :name,
    :type,
    :race,
    :description,
    :release_packs,
    :level,
    :attribute,
    :atk,
    :def,
    :booster_set,
    :booster_card_id
  ]
  @enforce_keys []
  defstruct @keys ++ @enforce_keys

  def parse(data) do
    %{
      "cd_name" => name,
      "cd_type" => type,
      "cd_attribute" => attribute,
      "cd_subtype" => race,
      "cd_level" => level,
      "cd_atk" => atk,
      "cd_def" => def,
      "cd_card_text" => description,
      "set_seo_name" => release_pack,
      "cd_set" => booster_set,
      "cd_id" => booster_card_id
    } = data

    %{
      name: name,
      type: type,
      attribute: attribute,
      race: race,
      level: level,
      atk: atk,
      def: def,
      description: description,
      booster_set: booster_set,
      booster_card_id: booster_card_id,
      release_packs: [release_pack]
    }
    |> then(&struct(Card, &1))
  end
end
