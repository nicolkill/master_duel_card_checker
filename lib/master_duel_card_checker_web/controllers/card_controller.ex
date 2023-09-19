defmodule MasterDuelCardCheckerWeb.CardController do
  use MasterDuelCardCheckerWeb, :controller

  alias MasterDuelCardChecker.CardDatabase

  action_fallback MasterDuelCardCheckerWeb.FallbackController

  def index(conn, _params) do
    cards = CardDatabase.list_cards()
    render(conn, :index, cards: cards)
  end

  def sync(conn, _params) do
    MasterDuelCardChecker.Workers.ScheduleBoosters.start_job()

    json(conn, %{result: "ok"})
  end
end
