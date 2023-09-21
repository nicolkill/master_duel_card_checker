defmodule MasterDuelCardChecker.Integrations.YugiohCardGuide do
  use Tesla
  use ExCrawlzy.Client.JsonList

  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card

  defimpl Jason.Encoder, for: Card do
    def encode(value, opts) do
      Jason.Encode.map(Map.drop(value, [:__struct__]), opts)
    end
  end

  @site_url "https://www.yugiohcardguide.com"
  @booster_packs_path "/yugioh-booster-packs.html"

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, @site_url

  list_size(300)
  list_selector("section ul.flush li")
  add_field(:name, "a:first-child", :text)
  add_field(:id, "a:first-child", :link)

  def link(doc) do
    "href"
    |> ExCrawlzy.Utils.props(doc)
    |> String.replace(".html", "")
    |> String.split("/")
    |> Enum.at(2)
  end

  def get_booster_packs() do
    crawl("#{@site_url}#{@booster_packs_path}")
    |> Enum.dedup_by(& &1.id)
    |> Enum.with_index()
    |> Enum.map(&Map.put(elem(&1, 0), :index, elem(&1, 1)))
  end

  defp search(search), do: %{set: search}

  @spec list_cards(String.t()) :: [%Card{}]
  def list_cards(set) do
    search = search(set)

    {:ok, %Tesla.Env{body: data, status: 200}} =
      get("/Templates/7new-sets-json.php", query: search)

    Enum.map(data, &Card.parse/1)
    |> Enum.dedup_by(& &1.name)

    #  rescue
    #    _ ->
    #      []
  end
end
