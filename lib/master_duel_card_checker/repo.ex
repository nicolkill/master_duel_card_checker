defmodule MasterDuelCardChecker.Repo do
  use Ecto.Repo,
    otp_app: :master_duel_card_checker,
    adapter: Ecto.Adapters.Postgres
end
