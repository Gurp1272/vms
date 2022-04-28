defmodule Vms.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :title, :string, null: false
    field :date_start_scheduling, :utc_datetime, null: false
    field :date_start, :utc_datetime, null: false
    field :date_end, :utc_datetime, null: false

    belongs_to :manager, Vms.Manager
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [])
    |> validate_required([])
  end
end
