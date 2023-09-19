defmodule MasterDuelCardCheckerWeb.Router do
  use MasterDuelCardCheckerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", MasterDuelCardCheckerWeb do
    pipe_through :api

    get "/cards", CardController, :index
    post "/cards/sync", CardController, :sync
  end
end
