defmodule QuickInvest.Events.Consumer do
  use GenServer

  require Logger

  alias QuickInvest.Events.Event
  alias QuickInvest.Events.Queue
  alias QuickInvest.Notifier
  alias QuickInvest.Events.Store, as: EventStore

  @timeout :timer.seconds(5)
  @logger_prefix "[EventsConsumer] "

  def start_link(args) do
    GenServer.start_link(__MODULE__, %{id: Keyword.get(args, :id)})
  end

  def init(state) do
    {:ok, state, @timeout}
  end

  def handle_info(:timeout, state) do
    case Queue.consume() do
      nil ->
        {:noreply, state, @timeout}

      event ->
        Logger.debug(@logger_prefix <> " Consumer: #{state.id} consuming event",
          ansi_color: :magenta
        )

        case Event.build_struct(event) do
          {:ok, %Event{} = event_struct} ->
            dispatch_notifications(event_struct)
            {:noreply, state, @timeout}

          _ ->
            {:noreply, state, @timeout}
        end
    end
  end

  defp dispatch_notifications(event) do
    EventStore.add(event)

    Notifier.Email.notify(event)
    Notifier.MobilePush.notify(event)
  end
end
