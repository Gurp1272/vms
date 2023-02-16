defmodule VmsWeb.VolunteerAuthPlug do
  alias Vms.Genserver.Access
  import Phoenix.LiveView.Controller, only: [live_render: 3]

  def authenticate_volunteer(conn, _opts) do
    case valid_uuid?(conn) do
      true ->
        conn
        |> Plug.Conn.put_status(200)

      _ ->
        conn
        |> Plug.Conn.put_status(401)
        |> live_render(VmsWeb.InvalidLive, session: %{})
        |> Plug.Conn.halt()
    end
  end

  defp valid_uuid?(%Plug.Conn{params: %{"uuid" => uuid}}), do: Access.valid?(uuid)
end
