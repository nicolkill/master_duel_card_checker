defmodule MasterDuelCardCheckerWeb.CardController do
  use MasterDuelCardCheckerWeb, :controller

  alias MasterDuelCardChecker.CardDatabase
  alias MasterDuelCardChecker.Integrations.YugiohCardGuide

  action_fallback MasterDuelCardCheckerWeb.FallbackController

  def boosters(conn, _params) do
    boosters = YugiohCardGuide.get_booster_packs()
    render(conn, :index, boosters: boosters)
  end

  def index(conn, %{"booster" => booster, "page" => page}) do
    page = String.to_integer(page)
    cards = CardDatabase.list_cards_by_booster(booster, page)
    render(conn, :index, cards: cards)
  end

  def index(conn, _params) do
    cards = CardDatabase.list_cards()
    render(conn, :index, cards: cards)
  end

  def sync(conn, _params) do
    MasterDuelCardChecker.Workers.ScheduleBoosters.start_job()

    json(conn, %{result: "ok"})
  end
end
