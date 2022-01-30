defmodule Qukath.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Qukath.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Qukath.PubSub}
      # Start a worker by calling: Qukath.Worker.start_link(arg)
      # {Qukath.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Qukath.Supervisor)
  end
end
