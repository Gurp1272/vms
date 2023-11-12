defmodule VmsWeb.InvalidLive do
  use VmsWeb, :live_view

  alias Vms.Volunteers
  alias Vms.Volunteers.Volunteer

  def render(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="flex-col">
        <div class="card w-96 bg-primary text-primary-content">
          <div class="card-body">
            <h2 class="card-title">Invalid or Expired link</h2>
            <p>Use the button below to request another.</p>
            <div class="card-actions justify-end">
              <button class="btn btn-secondary" phx-click={show_modal("request-modal")}>
                Request Link
              </button>
            </div>
          </div>
        </div>
      </div>

      <.request_modal for={@form} />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok,
     socket
     |> assign(:form, to_form(changeset))}
  end

  def handle_event(
        "save",
        %{"first_name" => _first_name, "last_name" => _last_name, "phone" => _phone} = params,
        socket
      ) do
    changeset = Volunteers.change_volunteer(%Volunteer{})
    request_link(params)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("validate", params, socket) do
    form =
      %Volunteer{}
      |> Volunteers.change_volunteer(params)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, form: form)}
  end

  defp request_link(params) do
    Task.Supervisor.start_child(
      Vms.RequestSupervisor,
      fn ->
        Volunteers.request_link(params)
      end,
      shutdown: 60_000
    )
  end
end
