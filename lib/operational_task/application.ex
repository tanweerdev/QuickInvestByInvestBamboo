defmodule QuickInvest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # We're not using repo
      # QuickInvest.Repo,

      # Start the PubSub system
      {Phoenix.PubSub, name: QuickInvest.PubSub},
      # Start Finch
      {Finch, name: QuickInvest.Finch},
      # Start the Endpoint (http/https)
      QuickInvestWeb.Endpoint,
      QuickInvest.Events.Supervisor,
      QuickInvest.Users.Store,
      QuickInvest.Events.Store
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuickInvest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuickInvestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
