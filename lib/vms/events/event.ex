defmodule Vms.Events.Event do
  alias Vms.Positions.Position
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :name, :string
    field :event_starttime, :utc_datetime
    field :event_endtime, :utc_datetime
    has_many :positions, Position
    has_many :volunteers, through: [:positions, :volunteers]

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, ~w[name event_starttime event_endtime]a)
    |> validate_required(~w[name event_starttime event_endtime]a)
  end
end
