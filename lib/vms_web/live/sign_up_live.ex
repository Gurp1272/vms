defmodule VmsWeb.SignUpLive do
  use VmsWeb, :live_view
  require Logger

  alias Vms.Presence
  alias Vms.PubSub
  alias Vms.Access
  alias Vms.Volunteers.Volunteer
  alias Vms.Volunteers
  alias Vms.Positions
  alias Vms.Events

  @presence "vms:presence"

  def render(assigns) do
    ~H"""
    <.flash kind={:info} title="Success!" flash={@flash} />
    <.flash kind={:error} title="Error :(" flash={@flash} />

    <div>
      <div class="navbar bg-neutral text-neutral-content mb-2">
        <div class="flex-1">
          <div class="mr-4">
            <button class="btn btn-primary btn-xs" phx-click={show_modal("request-modal")}>
              Request Link
            </button>
          </div>
        </div>
        <div class="flex-none">
          <div>
            <%= @volunteer.first_name %> <%= @volunteer.last_name %>
          </div>
        </div>
      </div>

      <.request_modal for={@form} />

      <div class="p-2 bg-info-content rounded-md mb-4">
        <div class="text-white font-bold mb-2">Active Users</div>

        <div class="flex flex-row flex-wrap gap-2 max-h-32 overflow-hidden">
          <%= for {_user_id, user} <- @users do %>
            <div class={random_badge(user)}>
              <%= user.name %>
            </div>
          <% end %>
        </div>
      </div>
      <!-- Mobile -->
      <div class="flex flex-col">
        <div
          tabindex="0"
          class="collapse collapse-plus border border-base-300 bg-base-100 rounded-box mb-6"
        >
          <div class="collapse-title text-xl font-medium">
            My Upcoming Duties
          </div>
          <div class="collapse-content">
            <div class="overflow-x-auto">
              <table class="table table-compact table-zebra w-full">
                <!-- head -->
                <thead>
                  <tr>
                    <th>Date</th>
                    <th>Start Time</th>
                    <th>End Time</th>
                    <th>Event</th>
                    <th>Position</th>
                  </tr>
                </thead>
                <tbody>
                  <%= for event <- @my_upcoming_events do %>
                    <%= for position <- event.positions do %>
                      <tr>
                        <td><%= Calendar.strftime(position.shift_starttime, "%b %d, %Y") %></td>
                        <td><%= Calendar.strftime(position.shift_starttime, "%I:%M %P") %></td>
                        <td><%= Calendar.strftime(position.shift_endtime, "%I:%M %P") %></td>
                        <td><%= event.name %></td>
                        <td><%= position.title %></td>
                      </tr>
                    <% end %>
                  <% end %>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <h1 class="text-4xl place-self-center mb-2">Open Positions</h1>

        <%= for event <- @upcoming_events_with_open_positions do %>
          <div
            tabindex="0"
            class="collapse collapse-open border border-base-300 bg-base-100 rounded-box mb-6"
          >
            <div class="collapse-title text-xl font-medium">
              <%= event.name %> on <%= Calendar.strftime(event.event_starttime, "%b %d, %Y") %>
            </div>
            <div class="collapse-content">
              <div class="overflow-x-auto">
                <div class="overflow-x-auto">
                  <table class="table table-compact table-zebra w-full">
                    <!-- head -->
                    <thead>
                      <tr>
                        <th></th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Position</th>
                      </tr>
                    </thead>
                    <tbody>
                      <%= for position <- event.positions do %>
                        <tr>
                          <td>
                            <button
                              phx-click="fill"
                              phx-value-id={position.id}
                              phx-disable-with="Filling..."
                              data-confirm="Are you sure?"
                              class="btn bg-green-500 btn-xs text-black"
                            >
                              Fill
                            </button>
                          </td>
                          <td><%= Calendar.strftime(position.shift_starttime, "%I:%M %P") %></td>
                          <td><%= Calendar.strftime(position.shift_endtime, "%I:%M %P") %></td>
                          <td><%= position.title %></td>
                        </tr>
                      <% end %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(
        _params,
        %{
          "access_struct" => %Access{
            volunteer: %Volunteer{id: id} = volunteer
          }
        },
        socket
      ) do
    if connected?(socket) do
      Positions.subscribe()

      {:ok, _} =
        Presence.track(self(), @presence, id, %{
          name: "#{volunteer.first_name} #{volunteer.last_name}",
          joined_at: :os.system_time(:seconds)
        })

      Phoenix.PubSub.subscribe(PubSub, @presence)
    end

    my_upcoming_events = Events.my_upcoming_events(id)
    open_positions = Events.open_positions()
    changeset = Volunteers.change_volunteer(%Volunteer{})

    {:ok,
     socket
     |> assign(:volunteer, volunteer)
     |> assign(:users, %{})
     |> assign(:my_upcoming_events, my_upcoming_events)
     |> assign(:upcoming_events_with_open_positions, open_positions)
     |> assign(:form, to_form(changeset))
     |> handle_joins(Presence.list(@presence))}
  end

  def handle_info(%Phoenix.Socket.Broadcast{event: "presence_diff", payload: diff}, socket) do
    {:noreply,
     socket
     |> handle_leaves(diff.leaves)
     |> handle_joins(diff.joins)}
  end

  def handle_info({:position_updated, position}, socket)
      when position.volunteer_id == socket.assigns.volunteer.id do
    open_positions = Events.open_positions()
    my_upcoming_events = Events.my_upcoming_events(socket.assigns.volunteer.id)

    {:noreply,
     assign(socket,
       upcoming_events_with_open_positions: open_positions,
       my_upcoming_events: my_upcoming_events
     )}
  end

  def handle_info({:position_updated, _position}, socket) do
    open_positions = Events.open_positions()

    {:noreply, assign(socket, upcoming_events_with_open_positions: open_positions)}
  end

  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
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

  def handle_event("fill", %{"id" => position_id}, socket) do
    position = Positions.get_position!(position_id)

    case Positions.update_position(position, %{volunteer_id: socket.assigns.volunteer.id}) do
      {:ok, position} ->
        Process.send_after(self(), :clear_flash, 6000)

        {:noreply,
         put_flash(
           socket,
           :info,
           "You have signed up for #{position.title} starting at #{position.shift_starttime}."
         )}

      {:error, changeset} ->
        case schedule_conflict?(changeset) do
          true ->
            Process.send_after(self(), :clear_flash, 6000)

            {:noreply,
             put_flash(
               socket,
               :error,
               "The position you attempted to fill has a schedule conflict with a position you're already filling."
             )}

          _ ->
            Process.send_after(self(), :clear_flash, 6000)

            {:noreply,
             put_flash(
               socket,
               :error,
               "There was an error filling the position."
             )}
        end
    end
  end

  def random_badge(user) do
    cond do
      String.starts_with?(String.downcase(user.name), ["a", "b", "c", "d", "e", "f", "g"]) ->
        "badge badge-primary"

      String.starts_with?(String.downcase(user.name), ["h", "i", "j", "k", "l", "m", "n"]) ->
        "badge badge-secondary"

      String.starts_with?(String.downcase(user.name), ["o", "p", "q", "r", "s", "t"]) ->
        "badge badge-accent"

      String.starts_with?(String.downcase(user.name), ["u", "v", "w", "x", "y", "z"]) ->
        "badge"

      true ->
        "badge"
    end
  end

  defp schedule_conflict?(%Ecto.Changeset{} = changeset) do
    case changeset.errors[:shift_starttime] do
      {"schedule conflict", _} -> true
      _ -> false
    end
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user))
    end)
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
