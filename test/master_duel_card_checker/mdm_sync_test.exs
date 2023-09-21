defmodule MasterDuelCardChecker.MdmSyncTest do
  use MasterDuelCardChecker.DataCase

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.CardDatabase.Card
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card, as: YugiohCardGuideCard

  import Tesla.Mock

  setup do
    mock(fn
      %{method: :get, url: "https://www.masterduelmeta.com/api/v1/cards" <> _} ->
        %Tesla.Env{
          status: 200,
          body: [
            %{
              "__v" => 0,
              "_id" => "62de1eaae9066c4257aa9526",
              "deckTypes" => [],
              "description" =>
                "At the start of your Main Phase 1: Apply 1 of the following effects until the end of your opponent's turn.\n● Neither player can activate card effects in the GY.\n● Neither player can banish cards from the GY.\n● Neither player can Special Summon monsters from the GYs.",
              "gameId" => 17727,
              "imageHash" => "crc32c=DZt9sQ==, md5=rKEsdxcjsh/3sRDnBBeQ4w==",
              "isUpdated" => true,
              "konamiID" => "59494222",
              "linkArrows" => [],
              "monsterType" => [],
              "mostUsedDeckTypes" => [],
              "name" => "Gravekeeper's Inscription",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64ed9dded69aa6db12f8c802",
                    "name" => "Inherited Unity",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgRelease" => "2022-05-27T00:00:00.000Z",
              "popRank" => 1.7976931348623157e308,
              "race" => "Normal",
              "rarity" => "SR",
              "release" => "2023-08-29T07:20:00.000Z",
              "type" => "Spell"
            }
          ]
        }
    end)

    :ok
  end

  test "sync booster packs" do
    ycg_data = %{
      "cd_atk" => "",
      "cd_attribute" => "",
      "cd_card_text" =>
        "At the start of your Main Phase 1: Apply 1 of the following effects until the end of your opponent's turn.<br><li>Neither player can activate card effects in the GY.<br><li>Neither player can activate card effects in the GY.<br><li>Neither player can Special Summon monsters from the GYs.",
      "cd_def" => "",
      "cd_effect" => "",
      "cd_id" => "PHHY-EN000",
      "cd_level" => "",
      "cd_link" => "",
      "cd_name" => "Gravekeeper's Inscription",
      "cd_pendulum" => "",
      "cd_rarity" => "Secret Rare",
      "cd_seo_name" => "gravekeepers-inscription",
      "cd_set" => "PHHY",
      "cd_subtype" => "Normal",
      "cd_type" => "Spell",
      "set_name" => "Photon Hypernova",
      "set_seo_name" => "photon-hypernova-booster-pack",
      "set_type" => "Booster Pack"
    }
    assert %YugiohCardGuideCard{} = ycg_card = YugiohCardGuideCard.parse(ycg_data)

    assert {:ok, %Card{
             name: "Gravekeeper's Inscription",
             ycg_data: %{
               name: "Gravekeeper's Inscription"
             },
             mdm_data: nil
           }} = CardDatabase.create_card(%{
             name: ycg_card.name,
             ycg_booster: Enum.dedup(ycg_card.release_packs),
             ycg_data: ycg_card
           })


    assert :ok = perform_job(MasterDuelCardChecker.Workers.MdmSync, %{page: 0})
    assert [%Card{name: "Gravekeeper's Inscription"} = card | _] = CardDatabase.list_cards(0)

    assert %Card{
             name: "Gravekeeper's Inscription",
             ycg_data: %{
               "name" => "Gravekeeper's Inscription"
             },
             mdm_data: %{
               "name" => "Gravekeeper's Inscription"
             }
           } = card
  end
end
