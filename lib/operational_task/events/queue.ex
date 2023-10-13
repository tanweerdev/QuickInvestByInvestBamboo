defmodule QuickInvest.Events.Queue do
  @moduledoc """
  Queue recieves events from SourceSubscriber, and stores
  in a Queue contained within. The main purpose of this Queue is to
  handle back-pressure. Consumer(s) shall consume from this queue and process
  the recieved events respectively.
  """
  require Logger

  use GenServer
  @logger_prefix "[EventsQueue] "

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:ok, :queue.new()}
  end

  #
  # Client API
  #

  @doc """
  Add events to queue
  """
  @spec add(list(map())) :: :ok
  def add(events) do
    GenServer.cast(__MODULE__, {:add, events})
  end

  @doc """
  Consume/extract event from queue
  """
  @spec consume() :: map()
  def consume() do
    GenServer.call(__MODULE__, :consume)
  end

  #
  # Server Callbacks
  #

  def handle_cast({:add, events}, queue = _state) do
    updated_queue = Enum.reduce(events, queue, &:queue.in(&1, &2))
    {:noreply, updated_queue}
  end

  def handle_call(:consume, _from, queue = _states) do
    {updated_queue, response} =
      case :queue.out(queue) do
        {:empty, q} -> {q, nil}
        {{_, value}, q} -> {q, value}
      end

    Logger.debug(@logger_prefix <> " Remaining events: #{:queue.len(updated_queue)}")

    {:reply, response, updated_queue}
  end
end
