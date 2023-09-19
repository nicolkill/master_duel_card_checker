defmodule MasterDuelCardCheckerWeb.CardControllerTest do
  use MasterDuelCardCheckerWeb.ConnCase

  import MasterDuelCardChecker.CardDatabaseFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_cards]

    test "lists all cards", %{conn: conn} do
      conn = get(conn, ~p"/api/v1/cards")
      assert [%{ "id" => _, "mdm_data" => %{"name" => "Kashtira Fenrir"} }] = json_response(conn, 200)["data"]
    end
  end

  defp create_cards(_) do
    card = card_fixture()
    %{card: card}
  end
end
