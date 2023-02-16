defmodule VmsWeb.SignUpLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
      Test
      <%= @uuid %>
    """
  end

  def mount(%{"uuid" => uuid}, _session, socket) do
    {:ok, assign(socket, :uuid, uuid)}
  end
end
