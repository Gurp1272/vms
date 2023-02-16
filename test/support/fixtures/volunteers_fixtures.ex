defmodule Vms.VolunteersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vms.Volunteers` context.
  """

  @doc """
  Generate a volunteer.
  """
  def volunteer_fixture(attrs \\ %{}) do
    {:ok, volunteer} =
      attrs
      |> Enum.into(%{
        datetime_last_contact: ~U[2023-02-13 04:38:00Z],
        datetime_last_served: ~U[2023-02-13 04:38:00Z],
        first_name: "some first_name",
        last_name: "some last_name",
        note: "some note",
        phone: "some phone",
        times_contacted: 42,
        times_filled: 42,
        total_time_served: "some total_time_served"
      })
      |> Vms.Volunteers.create_volunteer()

    volunteer
  end
end
