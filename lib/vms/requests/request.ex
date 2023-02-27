defmodule Vms.Requests.Request do
  use Ecto.Schema
  import Ecto.Changeset

  schema "requests" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, ~w[first_name last_name phone]a)
    |> validate_required(~w[first_name last_name phone]a)
  end
end
