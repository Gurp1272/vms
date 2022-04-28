defmodule Vms.Scheduler do
  use Quantum, otp_app: :vms
  import Ecto.UUID
  import Ecto.Query
  alias Vms.Repo
  alias Vms.Post


  # Get all posts that need to start being filled today group by manager_id
  # Start genserver for each group and pass them respective posts
  def fetch_posts do
    {:ok, date} = DateTime.new(~D[2022-04-22], ~T[15:00:00])
    query = from p in Post, where: [date_start_scheduling: ^date], group_by: [p.manager_id, p.date_start, p.date_end], select: {p.manager_id, p.date_start, p.date_end, count(p.id)}

    Repo.all(query)
    |> Enum.group_by(&Kernel.elem(&1, 0))
    |> Map.to_list
    |> Enum.each(fn manager -> start_post_genserver(manager) end)
  end

  @doc """
  Input: {Integer, [{Integer, DateTime, DateTime, Integer}, {Integer, DateTime, ...}]}

  Output: [{Integer, DateTime, DateTime, Integer}, {Integer, DateTime, ...}]
  """
  defp posts({_, posts}) do
    posts
  end

  defp start_post_genserver(manager) do
    DynamicSupervisor.start_child(Vms.DynamicSupervisor, %{id: "#{Ecto.UUID.generate}", start: {Vms.GenServers.Post, :start_link, [posts(manager)]}})

    IO.puts "TEST3"
    IO.inspect(DynamicSupervisor.count_children(Vms.DynamicSupervisor
))
  end
end

# {:ok, date_start_scheduling} = DateTime.new(~D[2022-04-22], ~T[15:00:00])
# {:ok, ~U[2022-04-22 15:00:00Z]}
# iex(20)> date_start_scheduling
# ~U[2022-04-22 1-5:00:00Z]
# iex(21)> {:ok, date_start} = DateTime.new(~D[2022-04-27], ~T[16:00:00])
# {:ok, ~U[2022-04-27 16:00:00Z]}
# iex(22)> {:ok, date_end} = DateTime.new(~D[2022-04-27], ~T[18:00:00])
# {:ok, ~U[2022-04-27 18:00:00Z]}
# iex(23)> post = %Vms.Post{title: "Gate Guard", date_start_scheduling: date_start_scheduling, date_start: date_start, date_end: date_end, manager_id: 1}

