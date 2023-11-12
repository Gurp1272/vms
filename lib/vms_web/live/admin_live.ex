defmodule VmsWeb.AdminLive do
  use VmsWeb, :live_view

  def render(assigns) do
    ~H"""
    Test
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
