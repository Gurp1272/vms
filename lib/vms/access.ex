defmodule Vms.Access do
  alias Ecto.UUID
  alias Vms.Access
  alias Vms.Volunteers.Volunteer

  defstruct ~w[volunteer uuid expiry]a

  @typedoc "Access struct type, contains volunteer id, uuid, and expiry"
  @type t :: %Vms.Access{volunteer: %Volunteer{}, uuid: Ecto.UUID.t(), expiry: DateTime.t()}

  @expiry_in_hours 24

  @spec generate_structs([%Volunteer{}]) :: [%Access{}]
  def generate_structs(volunteers) do
    volunteers
    |> Enum.reduce([], fn volunteer, acc ->
      [generate_struct(volunteer) | acc]
    end)
  end

  defp generate_struct(%Volunteer{} = volunteer) do
    %Access{}
    |> Map.put(:volunteer, volunteer)
    |> generate_uuid()
    |> generate_expiry()
  end

  defp generate_uuid(%Access{} = access_struct) do
    access_struct
    |> Map.put(:uuid, UUID.generate())
  end

  defp generate_expiry(%Access{} = access_struct) do
    expiry =
      DateTime.utc_now()
      |> DateTime.add(@expiry_in_hours, :hour)

    access_struct
    |> Map.put(:expiry, expiry)
  end
end
