defmodule Vms.Volunteer do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "volunteers" do
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :age, :integer
    field :phone, :string, null: false

    belongs_to :manager, Vms.Manager
    timestamps()
  end

  @doc false
  def changeset(volunteer, attrs) do
    volunteer
    |> cast(attrs, [])
    |> validate_required([])
  end
end
