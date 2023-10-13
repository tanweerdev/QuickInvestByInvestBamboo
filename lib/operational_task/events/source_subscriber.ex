defmodule QuickInvest.Events.SourceSubscriber do
  # we could name it EventProducer
  @moduledoc """
  Subscriber to the source, this is to mock Pub/Sub over websocket (presumebly).
  Publisher being the 3rd party service which is source of events.
  SourceScriber will preodically publish recieved events to the PublisherQueue module.
  """

  use GenServer

  alias QuickInvest.Events.Queue

  @timeout :timer.seconds(20)
  # name can be improved
  @events_range 0..1_00

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(state) do
    # using timeout 0 here as we want the first timeout
    # to be immediate
    {:ok, state, 0}
  end

  def handle_info(:timeout, state) do
    fetched_events = fetch()

    Queue.add(fetched_events)

    {:noreply, state, @timeout}
  end

  def fetch(events_range \\ @events_range) do
    num_of_events = Enum.random(events_range)
    Enum.map(1..num_of_events, &event_payload/1)
  end

  defp event_payload(_) do
    %{
      company_name: Faker.Company.En.name(),
      category: Enum.random(Ecto.Enum.values(QuickInvest.Users.User, :preferred_category)),
      enabled: Enum.random([true, true, true, false])
    }
  end
end
