defmodule Vms.Genserver.Access do
  use GenServer
  require Logger

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
  def handle_call({:pop, key}, _from, access_key_map) do
    {popped, new_map} =
      access_key_map
      |> pop(key)

    {:reply, popped, new_map}
  end

  def handle_call({:valid?, uuid}, _from, access_key_map) do
    {:reply, Map.has_key?(access_key_map, uuid), access_key_map}
  end

  def handle_call({:fetch, uuid}, _from, access_key_map) do
    {:reply, Map.fetch(access_key_map, uuid), access_key_map}
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
  def start_link(map) when is_map(map) do
    GenServer.start_link(__MODULE__, map, name: __MODULE__)
  end

  def pop(key) do
    GenServer.call(__MODULE__, {:pop, key})
  end

  def put(key, value) do
    GenServer.cast(__MODULE__, {:put, key, value})
  end

  def valid?(uuid) do
    GenServer.call(__MODULE__, {:valid?, uuid})
  end

  def fetch(key) do
    GenServer.call(__MODULE__, {:fetch, key})
  end


  # Private functions

  defp pop(access_key_map, key), do: Map.pop(access_key_map, key)

  defp put(access_key_map, key, value) do
    Map.put_new(access_key_map, key, value)
  end

  defp schedule_scrub() do
    Process.send_after(self(), :scrub, @five_minutes)
  end

  # when map is empty
  defp scrub(access_key_map) when access_key_map == %{} do
    Logger.info("Access state is empty")
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
