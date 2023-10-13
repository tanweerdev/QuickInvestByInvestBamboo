defmodule QuickInvest.Events.Supervisor do
  use Supervisor

  alias QuickInvest.Events

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    children = [
      Events.ConsumerSupervisor,
      Events.Queue,
      Events.SourceSubscriber
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
