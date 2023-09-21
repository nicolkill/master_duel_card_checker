defmodule MasterDuelCardChecker.WorkersDiverseTest do
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
              "_id" => "some id 1",
              "deckTypes" => [],
              "description" =>
                "description",
              "gameId" => 17727,
              "imageHash" => "crc32c=DZt9sQ==, md5=rKEsdxcjsh/3sRDnBBeQ4w==",
              "isUpdated" => true,
              "konamiID" => "59494222",
              "linkArrows" => [],
              "monsterType" => [],
              "mostUsedDeckTypes" => [],
              "name" => "Some Existing card",
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
              "_id" => "some id 2",
              "deckTypes" => [],
              "description" =>
                "description",
              "gameId" => 17727,
              "imageHash" => "crc32c=DZt9sQ==, md5=rKEsdxcjsh/3sRDnBBeQ4w==",
              "isUpdated" => true,
              "konamiID" => "59494222",
              "linkArrows" => [],
              "monsterType" => [],
              "mostUsedDeckTypes" => [],
              "name" => "Not Existing card",
              "obtain" => [],
              "ocgRelease" => "2022-05-27T00:00:00.000Z",
              "popRank" => 1.7976931348623157e308,
              "race" => "Normal",
              "type" => "Spell"
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
              "cd_card_text" => "description",
              "cd_def" => "",
              "cd_effect" => "",
              "cd_id" => "PHHY-EN000",
              "cd_level" => "",
              "cd_link" => "",
              "cd_name" => "Some Existing card",
              "cd_pendulum" => "",
              "cd_rarity" => "Secret Rare",
              "cd_seo_name" => "some-existing-card",
              "cd_set" => "PHHY",
              "cd_subtype" => "Normal",
              "cd_type" => "Spell",
              "set_name" => "Photon Hypernova",
              "set_seo_name" => "photon-hypernova-booster-pack",
              "set_type" => "Booster Pack"
            },
            %{
              "cd_atk" => "",
              "cd_attribute" => "",
              "cd_card_text" => "description",
              "cd_def" => "",
              "cd_effect" => "",
              "cd_id" => "PHHY-EN000",
              "cd_level" => "",
              "cd_link" => "",
              "cd_name" => "Not Existing card",
              "cd_pendulum" => "",
              "cd_rarity" => "Secret Rare",
              "cd_seo_name" => "not-existing-card",
              "cd_set" => "PHHY",
              "cd_subtype" => "Normal",
              "cd_type" => "Spell",
              "set_name" => "Photon Hypernova",
              "set_seo_name" => "photon-hypernova-booster-pack",
              "set_type" => "Booster Pack"
            },
            %{
              "cd_atk" => "",
              "cd_attribute" => "",
              "cd_card_text" => "description",
              "cd_def" => "",
              "cd_effect" => "",
              "cd_id" => "PHHY-EN000",
              "cd_level" => "",
              "cd_link" => "",
              "cd_name" => "Super New card",
              "cd_pendulum" => "",
              "cd_rarity" => "Secret Rare",
              "cd_seo_name" => "super-new-card",
              "cd_set" => "PHHY",
              "cd_subtype" => "Normal",
              "cd_type" => "Spell",
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
    assert [%Card{name: "Not Existing card"} = card | _] = CardDatabase.list_cards(0)

    assert %Card{
             name: "Not Existing card",
             ycg_data: %{
               "name" => "Not Existing card"
             },
             mdm_data: %{
               "name" => "Not Existing card"
             }
           } = card
  end
end
