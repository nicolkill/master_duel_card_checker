import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :master_duel_card_checker, MasterDuelCardChecker.Repo,
  username: System.get_env("POSTGRES_USERNAME"),
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOSTNAME"),
  database: "#{System.get_env("POSTGRES_DATABASE")}_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :master_duel_card_checker, MasterDuelCardCheckerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "iRUVaaHkzAYbhTpNXkXh4nnaxqENrGOiW4tqhBSa3qEwByUcKJV2+LxbVdGBkK/D",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# test adapters
config :tesla, MasterDuelCardChecker.Integrations.MasterDuelMeta, adapter: Tesla.Mock
config :tesla, MasterDuelCardChecker.Integrations.YugiohCardGuide, adapter: Tesla.Mock
config :master_duel_card_checker, Oban, testing: :inline

