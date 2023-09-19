defmodule MasterDuelCardChecker.CardDatabase.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @keys [:name, :mdm_data, :ycg_data, :ycg_booster]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "cards" do
    field :name, :string
    field :ycg_booster, {:array, :string}
    field :ycg_data, :map
    field :mdm_data, :map

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, @keys)
    |> validate_required(@keys)
  end
end
