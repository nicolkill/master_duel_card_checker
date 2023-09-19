defmodule MasterDuelCardChecker.Integrations.MasterDuelMeta do
  use Tesla

  alias MasterDuelCardChecker.Integrations.MasterDuelMeta.Card

  plug Tesla.Middleware.BaseUrl, "https://www.masterduelmeta.com/api/v1"
  plug Tesla.Middleware.JSON

  defp search(search), do: %{ search: search }
  defp pagination(page),
       do: %{
         limit: 100,
         page: page,
         aggregate: "search",
         cardSort: "popRank"
       }

  @spec list_cards(String.t(), integer()) :: any()
  def list_cards(search, page \\ 1) do
    search = search(search)
    pagination = pagination(page)

    headers = [{"origin", "https://www.masterduelmeta.com"}]

    {:ok, %Tesla.Env{body: data, status: 200}} =
      get("/cards", headers: headers, query: Map.merge(search, pagination))

    Enum.map(data, &Card.parse/1)
  rescue
    _ ->
      []
  end

end