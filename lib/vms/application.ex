defmodule Vms.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VmsWeb.Telemetry,
      # Start the Ecto repository
      Vms.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Vms.PubSub},
      # Start Finch
      {Finch, name: Vms.Finch},
      # Start the Endpoint (http/https)
      VmsWeb.Endpoint,
      # Start a worker by calling: Vms.Worker.start_link(arg)
      # {Vms.Worker, arg}
      Vms.Scheduler,
      {Vms.Genserver.Access, %{}},
      Vms.Presence,
      {Task.Supervisor, name: Vms.RequestSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Vms.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VmsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
