defmodule VhsDevTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      VhsDevTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: VhsDevTest.PubSub},
      # Start the Endpoint (http/https)
      VhsDevTestWeb.Endpoint
      # Start a worker by calling: VhsDevTest.Worker.start_link(arg)
      # {VhsDevTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VhsDevTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    VhsDevTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
