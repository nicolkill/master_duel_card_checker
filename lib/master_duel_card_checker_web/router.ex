defmodule MasterDuelCardCheckerWeb.Router do
  use MasterDuelCardCheckerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", MasterDuelCardCheckerWeb do
    pipe_through :api

    get "/boosters", CardController, :boosters
    get "/cards", CardController, :index
    post "/cards/sync", CardController, :sync
    post "/cards/update", CardController, :update
  end
end
