# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :master_duel_card_checker,
  ecto_repos: [MasterDuelCardChecker.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :master_duel_card_checker, MasterDuelCardCheckerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: MasterDuelCardCheckerWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MasterDuelCardChecker.PubSub,
  live_view: [signing_salt: "8Qh51GwI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

allowed_sites =
  System.get_env("ALLOWED_SITES") ||
    "*"
    |> String.split(",")

config :cors_plug,
       origin: allowed_sites

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
