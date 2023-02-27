defmodule Vms.RequestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Vms.Requests` context.
  """

  @doc """
  Generate a request.
  """
  def request_fixture(attrs \\ %{}) do
    {:ok, request} =
      attrs
      |> Enum.into(%{

      })
      |> Vms.Requests.create_request()

    request
  end
end
