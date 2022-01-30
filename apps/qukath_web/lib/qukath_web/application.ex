defmodule QukathWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      QukathWeb.Telemetry,
      # Start the Endpoint (http/https)
      QukathWeb.Endpoint
      # Start a worker by calling: QukathWeb.Worker.start_link(arg)
      # {QukathWeb.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QukathWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QukathWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
