defmodule Vms.Supervisors.DynamicSupervisor do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def link_post(state) do
    # child_spec = %{Vms.GenServers.Post, start: {Vms.GenServers.Post, :start_link, state}}

    # DynamicSupervisor.start_child(__MODULE__, child_spec)
  end
end
