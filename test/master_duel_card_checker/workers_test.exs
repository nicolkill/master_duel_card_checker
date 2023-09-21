defmodule MasterDuelCardChecker.WorkersTest do
  use MasterDuelCardChecker.DataCase

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.CardDatabase.Card

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
            },
            %{
              "__v" => 0,
              "_id" => "62fc18e0c9c52ba40dd443d5",
              "alternateArt" => false,
              "atk" => 2800,
              "attribute" => "LIGHT",
              "deckTypes" => ["Galaxy Photon"],
              "def" => 1000,
              "description" =>
                "If this card is sent to the GY, except from the field, while another \"Photon\" or \"Galaxy\" monster is on your field or in your GY: You can Special Summon this card in Defense Position. You can only use this effect of \"Photon Emperor\" once per turn. After you Normal or Special Summon this card, you can Normal Summon 1 LIGHT monster during your Main Phase this turn, in addition to your Normal Summon/Set. (You can only gain this effect once per turn.)",
              "gameId" => "18146",
              "imageHash" => "crc32c=o0dYgQ==, md5=EDvx+xsqEQlC+XooLVgUug==",
              "isUpdated" => true,
              "konamiID" => "73478096",
              "linkArrows" => [],
              "monsterType" => ["Effect"],
              "mostUsedDeckTypes" => ["Galaxy Photon"],
              "name" => "Photon Emperor",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64f96fbdfeec518f49d18849",
                    "name" => "Galactic Evolution",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgRelease" => "2022-10-15T00:00:00.000Z",
              "popRank" => 934,
              "race" => "Warrior",
              "rarity" => "N",
              "release" => "2023-09-07T06:30:00.000Z",
              "type" => "Monster"
            },
            %{
              "__v" => 0,
              "_id" => "62fc105bc9c52ba40dd3d542",
              "alternateArt" => false,
              "atk" => 1600,
              "attribute" => "LIGHT",
              "deckTypes" => ["Galaxy Photon"],
              "def" => 1400,
              "description" =>
                "If this card is Normal or Special Summoned: You can target 1 \"Photon\" or \"Galaxy\" monster in your GY, except \"Galaxy Summoner\"; Special Summon it in Defense Position. You can target 1 other LIGHT monster you control; it becomes Level 4 until the end of this turn. You can only use each effect of \"Galaxy Summoner\" once per turn.",
              "gameId" => "18147",
              "imageHash" => "crc32c=KTPCYQ==, md5=gvEFFdDw5ZkPtj8VHUbn1A==",
              "isUpdated" => true,
              "konamiID" => "863795",
              "linkArrows" => [],
              "monsterType" => ["Effect"],
              "mostUsedDeckTypes" => ["Galaxy Photon"],
              "name" => "Galaxy Summoner",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64f96fbdfeec518f49d18849",
                    "name" => "Galactic Evolution",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgRelease" => "2022-10-15T00:00:00.000Z",
              "popRank" => 933,
              "race" => "Spellcaster",
              "rarity" => "N",
              "release" => "2023-09-07T06:30:00.000Z",
              "type" => "Monster"
            }
          ]
        }

      %{method: :get, url: "https://www.yugiohcardguide.com/Templates/7new-sets-json.php" <> _} ->
        %Tesla.Env{
          status: 200,
          body: [
            %{
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
            },
            %{
              "cd_atk" => "2800",
              "cd_attribute" => "Light",
              "cd_card_text" =>
                "If this card is sent to the GY, except from the field, while another \"Photon\" or \"Galaxy\" monster is on your field or in your GY: You can Special Summon this card in Defense Position. You can only use this effect of \"Photon Emperor\" once per turn. After you Normal or Special Summon this card, you can Normal Summon 1 LIGHT monster during your Main Phase this turn, in addition to your Normal Summon/Set. (You can only gain this effect once per turn.)",
              "cd_def" => "1000",
              "cd_effect" => "",
              "cd_id" => "PHHY-EN001",
              "cd_level" => "8",
              "cd_link" => "",
              "cd_name" => "Photon Emperor",
              "cd_pendulum" => "",
              "cd_rarity" => "Common",
              "cd_seo_name" => "photon-emperor",
              "cd_set" => "PHHY",
              "cd_subtype" => "Warrior",
              "cd_type" => "Effect Monster",
              "set_name" => "Photon Hypernova",
              "set_seo_name" => "photon-hypernova-booster-pack",
              "set_type" => "Booster Pack"
            },
            %{
              "cd_atk" => "1600",
              "cd_attribute" => "Light",
              "cd_card_text" =>
                "If this card is Normal or Special Summoned: You can target 1 \"Photon\" or \"Galaxy\" monster in your GY, except \"Galaxy Summoner\"; Special Summon it in Defense Position. You can target 1 other LIGHT monster you control; it becomes Level 4 until the end of this turn. You can only use each effect of \"Galaxy Summoner\" once per turn.",
              "cd_def" => "1400",
              "cd_effect" => "",
              "cd_id" => "PHHY-EN002",
              "cd_level" => "4",
              "cd_link" => "",
              "cd_name" => "Galaxy Summoner",
              "cd_pendulum" => "",
              "cd_rarity" => "Common",
              "cd_seo_name" => "galaxy-summoner",
              "cd_set" => "PHHY",
              "cd_subtype" => "Spellcaster",
              "cd_type" => "Effect Monster",
              "set_name" => "Photon Hypernova",
              "set_seo_name" => "photon-hypernova-booster-pack",
              "set_type" => "Booster Pack"
            }
          ]
        }
    end)

    :ok
  end

  test "sync booster packs" do
    booster = "photon-hypernova-booster-pack"
    assert {:ok, [3]} = perform_job(MasterDuelCardChecker.Workers.BoosterSync, %{booster_id: booster})
    assert [%Card{name: "Galaxy Summoner"} = card | _] = CardDatabase.list_cards(0)

    assert %Card{
             name: "Galaxy Summoner",
             ycg_data: %{
               "name" => "Galaxy Summoner"
             },
             mdm_data: %{
               "name" => "Galaxy Summoner"
             }
           } = card
  end
end
