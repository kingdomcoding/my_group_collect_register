defmodule MyGroupCollectRegister.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  use Commanded.Application,
    otp_app: :my_group_collect_register,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: MyGroupCollectRegister.EventStore
    ]

  @impl true
  def start(_type, _args) do
    children = [
      MyGroupCollectRegisterWeb.Telemetry,
      MyGroupCollectRegister.Repo,
      {DNSCluster,
       query: Application.get_env(:my_group_collect_register, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyGroupCollectRegister.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: MyGroupCollectRegister.Finch},
      # Start a worker by calling: MyGroupCollectRegister.Worker.start_link(arg)
      # {MyGroupCollectRegister.Worker, arg},
      # Start to serve requests, typically the last entry
      MyGroupCollectRegisterWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyGroupCollectRegister.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyGroupCollectRegisterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
