defmodule MasterDuelCardCheckerWeb.Router do
  use MasterDuelCardCheckerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MasterDuelCardCheckerWeb do
    pipe_through :api
  end
end
