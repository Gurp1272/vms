defmodule Vms.Manager do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "managers" do
    field :first_name, :string, null: false
    field :last_name, :string, null: false
    field :phone, :string, null: false

    has_many :volunteers, Vms.Volunteer
    has_many :posts, Vms.Post
    timestamps()
  end

  @doc false
  def changeset(manager, attrs) do
    manager
    |> cast(attrs, [])
    |> validate_required([])
  end
end
