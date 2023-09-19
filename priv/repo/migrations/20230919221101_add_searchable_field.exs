defmodule MasterDuelCardChecker.Repo.Migrations.AddSearchableField do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :name, :string, null: false
    end

    create index(:cards, [:name], unique: true)
  end
end
