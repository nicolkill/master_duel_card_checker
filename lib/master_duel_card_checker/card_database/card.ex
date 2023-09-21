defmodule MasterDuelCardChecker.CardDatabase.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @required_keys [:name, :ycg_data, :ycg_booster]
  @keys [:mdm_data] ++ @required_keys

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
    |> validate_required(@required_keys)
  end
end
