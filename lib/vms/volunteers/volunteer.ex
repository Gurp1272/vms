defmodule Vms.Volunteers.Volunteer do
  alias Vms.Positions.Position
  use Ecto.Schema
  import Ecto.Changeset

  schema "volunteers" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :note, :string
    field :times_filled, :integer
    field :total_time_served, :string
    field :datetime_last_served, :utc_datetime
    field :times_contacted, :integer
    field :datetime_last_contact, :utc_datetime
    has_many :positions, Position
    has_many :events, through: [:positions, :events]

    timestamps()
  end

  @doc false
  def changeset(volunteer, attrs) do
    volunteer
    |> cast(attrs, ~w[first_name last_name phone note times_filled total_time_served datetime_last_served times_contacted datetime_last_contact]a)
    |> validate_required(~w[first_name last_name phone]a)
  end
end
