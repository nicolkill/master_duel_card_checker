defmodule MasterDuelCardChecker.Integrations.MasterDuelMeta do
  use Tesla

  alias MasterDuelCardChecker.Integrations.MasterDuelMeta.Card

  defimpl Jason.Encoder, for: Card do
    def encode(value, opts) do
      Jason.Encode.map(Map.drop(value, [:__struct__, :external_id, :game_id, :image_hash]), opts)
    end
  end

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, "https://www.masterduelmeta.com/api/v1"

  defp search(search), do: %{search: search}

  defp pagination(page),
    do: %{
      limit: 100,
      page: page,
      aggregate: "search",
      cardSort: "popRank"
    }

  @spec list_cards(String.t(), integer()) :: [%Card{}]
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
