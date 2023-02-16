defmodule Vms.Genserver.Access do
  use GenServer

  @moduledoc """
  Maintains map of %Vms.Access{} which have an expiry. Runs scrub to remove expired structs.

  This genserver is referred to when users access the site, to ensure their unique link is valid.
  """

  @five_minutes 5 * 60 * 1000

  # Callbacks

  @impl true
  def init(access_key_map) do
    schedule_scrub()
    {:ok, access_key_map}
  end

  @impl true
  def handle_call({:pluck, key}, _from, access_key_map) do
    {plucked, new_map} =
      access_key_map
      |> pluck(key)

    {:reply, plucked, new_map}
  end

  def handle_call({:valid?, uuid}, _from, access_key_map) do
    {:reply, Map.has_key?(access_key_map, uuid), access_key_map}
  end

  @impl true
  def handle_cast({:put, key, value}, access_key_map) do
    new_map = put(access_key_map, key, value)

    {:noreply, new_map}
  end

  @impl true
  def handle_info(:scrub, access_key_map) do
    new_map =
      access_key_map
      |> scrub()

    schedule_scrub()

    {:noreply, new_map}
  end

  # Client functions
  def start_link(map) do
    GenServer.start_link(__MODULE__, map, name: __MODULE__)
  end

  def pluck(key) do
    GenServer.call(__MODULE__, {:pluck, key})
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def valid?(uuid) do
    GenServer.call(__MODULE__, {:valid?, uuid})
  end

  # Private functions

  defp pluck(access_key_map, key), do: Map.pop(access_key_map, key)

  defp put(access_key_map, key, value), do: Map.put(access_key_map, key, value)

  defp schedule_scrub() do
    Process.send_after(self(), :scrub, @five_minutes)
  end

  defp scrub(access_key_map) do
    access_key_map
    |> Map.filter(fn {_key, map} ->
        expiry = Map.get(map, :expiry)

        case DateTime.compare(DateTime.utc_now, expiry) do
           :gt -> false
           _ -> true
        end
    end)
  end
end
