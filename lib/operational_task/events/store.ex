defmodule QuickInvest.Events.Store do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @spec add(any) :: :ok
  def add(event) do
    Agent.update(__MODULE__, &Map.put(&1, event.id, event))
  end

  def list(filters) do
    all_companies = Agent.get(__MODULE__, &Map.values(&1))

    filters
    |> build_filters()
    |> apply_filters(all_companies)
  end

  @spec generate_id :: integer()
  def generate_id() do
    Agent.get(__MODULE__, fn state ->
      state
      |> Map.values()
      |> length()
      |> Kernel.+(1)
    end)
  end

  defp apply_filters(filters, companies)

  defp apply_filters(filters, companies) do
    Enum.reduce(companies, [], fn company, acc ->
      f = MapSet.new(filters)
      c = company |> Map.from_struct() |> MapSet.new()

      if MapSet.subset?(f, c), do: [company | acc], else: acc
    end)
  end

  defp build_filters(%{"category" => category, "enabled" => enabled}),
    do: %{
      category: String.to_atom(category),
      enabled: enabled == "true"
    }

  defp build_filters(%{"category" => category}), do: %{category: String.to_atom(category)}
  defp build_filters(%{"enabled" => "true"}), do: %{enabled: true}
  defp build_filters(%{"enabled" => "false"}), do: %{enabled: false}
  defp build_filters(_), do: %{}
end
