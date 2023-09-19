defmodule YugiohCardGuideTest do
  use MasterDuelCardChecker.DataCase

  import Tesla.Mock

  alias MasterDuelCardChecker.Integrations.YugiohCardGuide
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card

  setup do
    {:ok, boosters_content} =
      :master_duel_card_checker
      |> :code.priv_dir()
      |> then(&"#{&1}/yugioh_card_guide_example.html")
      |> File.read()

    mock(fn
      %{method: :get, url: "https://www.yugiohcardguide.com/yugioh-booster-packs.html"} ->
        %Tesla.Env{
          status: 200,
          body: boosters_content
        }
      %{method: :get, url: "https://www.yugiohcardguide.com/Templates/7new-sets-json.php" <> _} ->
        %Tesla.Env{
          status: 200,
          body: [
            %{
              "cd_set" => "PHHY",
              "cd_id" => "PHHY-EN000",
              "cd_name" => "Gravekeeper's Inscription",
              "cd_seo_name" => "gravekeepers-inscription",
              "cd_type" => "Spell",
              "cd_attribute" => "",
              "cd_subtype" => "Normal",
              "cd_level" => "",
              "cd_link" => "",
              "cd_atk" => "",
              "cd_def" => "",
              "cd_card_text" => "Some desc",
              "cd_pendulum" => "",
              "cd_effect" => "",
              "cd_rarity" => "Secret Rare",
              "set_type" => "Booster Pack",
              "set_name" => "Photon Hypernova",
              "set_seo_name" => "photon-hypernova-booster-pack"
            }
          ]
        }
    end)

    :ok
  end

  test "get list of booster packs" do
    assert [%{name: "25th Anniversary Tin: Dueling Heroes Mega Pack"} | _] = YugiohCardGuide.get_booster_packs()
  end

  test "list cards of selected booster" do
    booster = "photon-hypernova-booster-pack"
    assert [%Card{name: "Gravekeeper's Inscription"} | _] = YugiohCardGuide.list_cards(booster)
  end
end