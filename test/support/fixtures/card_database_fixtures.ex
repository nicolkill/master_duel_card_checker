defmodule MasterDuelCardChecker.CardDatabaseFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MasterDuelCardChecker.CardDatabase` context.
  """

  @doc """
  Generate a card.
  """
  def card_fixture(attrs \\ %{}) do
    {:ok, card} =
      attrs
      |> Enum.into(%{
        name: "Kashtira Fenrir",
        ycg_booster: ["option1"],
        mdm_data: %{
          "game_id" => "17768",
          "external_id" => "62de2101e9066c4257aa9597",
          "image_hash" => "crc32c=W3BLOw==, md5=0NRz0GYyWCrI8JxH9mlpUQ==",
          "konami_id" => "32909498",
          "name" => "Kashtira Fenrir",
          "type" => "Monster Effect",
          "race" => "Warrior",
          "description" => "Some description",
          "ocg_release" => "2022-07-16T00:00:00.000Z",
          "rarity" => "UR",
          "release" => "2023-08-10T06:45:00.000Z",
          "release_packs" => ["Rage of Chaos"],
          "ban_status" => "Limited 2",
          "level" => 7,
          "attribute" => "EARTH",
          "atk" => 2400,
          "def" => 2400

        },
        ycg_data: %{
          "name" => "Kashtira Fenrir",
          "type" => "Effect Monster",
          "race" => "Warrior",
          "description" => "Some description",
          "release_packs" => ["Photon Hypernova"],
          "level" => "7",
          "attribute" => "EARTH",
          "atk" => "2400",
          "def" => "2400"
        }
      })
      |> MasterDuelCardChecker.CardDatabase.create_card()

    card
  end
end
