defmodule MasterDuelCardChecker.Integrations.YugiohCardGuide do
  use Tesla
  use ExCrawlzy.Client.JsonList

  alias MasterDuelCardChecker.Integrations.YugiohCardGuide.Card

  @site_url "https://www.yugiohcardguide.com"
  @booster_packs_path "/yugioh-booster-packs.html"

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.BaseUrl, @site_url

  list_size(200)
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
  end

  defp search(search), do: %{ set: search }

  @spec list_cards(String.t()) :: [%Card{}]
  def list_cards(set) do
    search = search(set)

    {:ok, %Tesla.Env{body: data, status: 200}} =
      get("/Templates/7new-sets-json.php", query: search)

    Enum.map(data, &Card.parse/1)
#  rescue
#    _ ->
#      []
  end

end