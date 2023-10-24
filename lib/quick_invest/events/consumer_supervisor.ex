defmodule QuickInvest.Events.ConsumerSupervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    get_consumer_count()
    |> maybe_build_childs()
    |> Supervisor.init(strategy: :one_for_one)
  end

  defp get_consumer_count() do
    :quick_invest
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.get(:consumer_count)
  end

  defp maybe_build_childs(count) when count > 0 do
    Enum.map(1..count, fn id ->
      spec = {QuickInvest.Events.Consumer, [id: id]}
      Supervisor.child_spec(spec, id: :"consumer-#{id}")
    end)
  end

  defp maybe_build_childs(_), do: []
end
