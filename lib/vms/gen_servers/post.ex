defmodule Vms.GenServers.Post do
  use GenServer

  def start_link(state) do
    IO.puts "TEST1"
    {:ok, _} = GenServer.start_link(__MODULE__, state, name: process_name())
    IO.puts "TEST2"
  end

  defp process_name, do: {:via, Registry, {PostRegistry, "#{__MODULE__} - #{Registry.count(PostRegistry)}"}}

  # Callbacks

  def init(posts) do
    {:ok, posts}
  end

  def handle_call(:get_posts, _from, posts) do
    {:reply, posts}
  end

  # def handle_call(:fill_post, _from, _) do
    # {:reply, filled_post}
  # end

  # for each post
  # {:ok, pid} = GenServer.start_link(Vms.GenServers.Message, %{})
end
