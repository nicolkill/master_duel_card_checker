defmodule MasterDuelCardChecker.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :mdm_data, :map
      add :ycg_data, :map
      add :ycg_booster, {:array, :string}

      timestamps()
    end
  end
end
