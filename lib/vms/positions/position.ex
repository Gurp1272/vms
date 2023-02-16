defmodule Vms.Positions.Position do
  alias Vms.Events.Event
  alias Vms.Volunteers.Volunteer
  use Ecto.Schema
  import Ecto.Changeset

  schema "positions" do
    field :title, :string
    field :shift_starttime, :utc_datetime
    field :shift_endtime, :utc_datetime
    field :lat, :float
    field :lng, :float
    belongs_to :event, Event
    belongs_to :volunteer, Volunteer

    timestamps()
  end

  @doc false
  def changeset(position, attrs) do
    position
    |> cast(attrs, ~w[title shift_starttime shift_endtime]a)
    |> validate_required(~w[title shift_starttime shift_endtime]a)
  end
end
