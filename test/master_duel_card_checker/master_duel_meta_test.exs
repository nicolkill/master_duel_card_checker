defmodule MasterDuelMetaTest do
  use MasterDuelCardChecker.DataCase

  import Tesla.Mock

  alias MasterDuelCardChecker.Integrations.MasterDuelMeta
  alias MasterDuelCardChecker.Integrations.MasterDuelMeta.Card

  setup do
    mock(fn
      %{method: :get, url: "https://www.masterduelmeta.com/api/v1/cards" <> _} ->
        %Tesla.Env{
          status: 200,
          body: [
            %{
              "__v" => 0,
              "_id" => "62de2101e9066c4257aa9597",
              "alternateArt" => false,
              "atk" => 2400,
              "attribute" => "EARTH",
              "banStatus" => "Limited 2",
              "deckTypes" => ["Labrynth"],
              "def" => 2400,
              "description" => "Some description",
              "gameId" => "17768",
              "imageHash" => "crc32c=W3BLOw==, md5=0NRz0GYyWCrI8JxH9mlpUQ==",
              "isUpdated" => true,
              "konamiID" => "32909498",
              "level" => 7,
              "linkArrows" => [],
              "monsterType" => ["Effect"],
              "mostUsedDeckTypes" => ["P.U.N.K."],
              "name" => "Kashtira Fenrir",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64d48b7b61436bed4861eff6",
                    "name" => "Rage of Chaos",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgBanStatus" => "Forbidden",
              "ocgRelease" => "2022-07-16T00:00:00.000Z",
              "popRank" => 9,
              "race" => "Psychic",
              "rarity" => "UR",
              "release" => "2023-08-10T06:45:00.000Z",
              "type" => "Monster"
            },
            %{
              "__v" => 0,
              "_id" => "62de2101e9066c4257aa959b",
              "alternateArt" => false,
              "atk" => 2500,
              "attribute" => "WIND",
              "deckTypes" => ["P.U.N.K."],
              "def" => 2100,
              "description" => "Some description",
              "gameId" => 17769,
              "imageHash" => "crc32c=4MTAMA==, md5=0IwWEOYFs9YjKV5Y/5SB7w==",
              "isUpdated" => true,
              "konamiID" => "68304193",
              "level" => 7,
              "linkArrows" => [],
              "monsterType" => ["Effect"],
              "mostUsedDeckTypes" => ["P.U.N.K."],
              "name" => "Kashtira Unicorn",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64d48b7b61436bed4861eff6",
                    "name" => "Rage of Chaos",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgBanStatus" => "Limited 1",
              "ocgRelease" => "2022-07-16T00:00:00.000Z",
              "popRank" => 43,
              "race" => "Psychic",
              "rarity" => "UR",
              "release" => "2023-08-10T06:45:00.000Z",
              "tcgBanStatus" => "Limited 2",
              "type" => "Monster"
            },
            %{
              "__v" => 0,
              "_id" => "62de2101e9066c4257aa9596",
              "deckTypes" => ["P.U.N.K."],
              "description" => "Some description",
              "gameId" => 17815,
              "imageHash" => "crc32c=MHCoLQ==, md5=5GJ6wuLDf8046CdOP3WCng==",
              "isUpdated" => true,
              "konamiID" => "69540484",
              "linkArrows" => [],
              "monsterType" => [],
              "mostUsedDeckTypes" => ["P.U.N.K."],
              "name" => "Kashtira Birth",
              "obtain" => [
                %{
                  "amount" => 1,
                  "source" => %{
                    "_id" => "64d48b7b61436bed4861eff6",
                    "name" => "Rage of Chaos",
                    "type" => "Selection Pack"
                  },
                  "type" => "sets"
                }
              ],
              "ocgRelease" => "2022-07-16T00:00:00.000Z",
              "popRank" => 44,
              "race" => "Continuous",
              "rarity" => "SR",
              "release" => "2023-08-10T06:45:00.000Z",
              "type" => "Spell"
            },
            %{
              "__v" => 0,
              "_id" => "632919edd4dd6c3fea9c1823",
              "atk" => 2300,
              "attribute" => "WATER",
              "deckTypes" => [],
              "def" => 1200,
              "description" => "Some description",
              "gameId" => 18153,
              "imageHash" => "crc32c=cv3xWQ==, md5=PL+Xqr5BS+mUX9nNGITMfg==",
              "isUpdated" => true,
              "konamiID" => "101111008",
              "level" => 7,
              "linkArrows" => [],
              "monsterType" => ["Effect"],
              "mostUsedDeckTypes" => [],
              "name" => "Tearlaments Kashtira",
              "obtain" => [],
              "ocgRelease" => "2022-10-15T00:00:00.000Z",
              "popRank" => 1.7976931348623157e308,
              "race" => "Psychic",
              "type" => "Monster"
            }
          ]
        }
    end)

    :ok
  end

  test "get card list and parses correctly" do
    assert [%Card{name: "Kashtira Fenrir"} | _rest] = MasterDuelMeta.list_cards("kashtira")
  end
end
