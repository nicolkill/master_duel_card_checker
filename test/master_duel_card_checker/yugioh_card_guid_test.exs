defmodule YugiohCardGuidTest do
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