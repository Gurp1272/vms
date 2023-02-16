defmodule Vms.PositionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vms.Positions` context.
  """

  @doc """
  Generate a position.
  """
  def position_fixture(attrs \\ %{}) do
    {:ok, position} =
      attrs
      |> Enum.into(%{

      })
      |> Vms.Positions.create_position()

    position
  end
end
