defmodule MasterDuelCardChecker.Workers.ScheduleBoosters do
  use Oban.Worker

  alias MasterDuelCardChecker.Integrations.YugiohCardGuide

  @impl Oban.Worker
  def perform(_args) do
    YugiohCardGuide.get_booster_packs()
    |> Enum.take(10)
    |> Enum.reduce(0, fn %{id: booster_id}, delay ->
      MasterDuelCardChecker.Workers.BoosterSync.enqueue_job(booster_id, delay)

      delay + 10
    end)

    :ok
  end

  @impl Oban.Worker
  def timeout(_job), do: :timer.seconds(30)

  def start_job() do
    %{}
    |> new()
    |> Oban.insert()
  end
end
