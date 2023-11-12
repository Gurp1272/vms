defmodule VmsWeb.VolunteerAuthPlug do
  alias Vms.Genserver.Access
  import Phoenix.LiveView.Controller, only: [live_render: 3]

  def authenticate_volunteer(%Plug.Conn{params: %{"uuid" => uuid}} = conn, _opts) do
    with {:ok, access_struct} <- Access.fetch(uuid) do
      conn
      |> Plug.Conn.put_status(200)
      |> Plug.Conn.put_session(:access_struct, access_struct)
    else
      _ ->
        conn
        |> Plug.Conn.put_status(401)
        |> Plug.Conn.delete_session(:access_struct)
        |> live_render(VmsWeb.InvalidLive, session: %{})
        |> Plug.Conn.halt()
    end
  end

  def authenticate_volunteer(conn, _opts), do: conn
end
