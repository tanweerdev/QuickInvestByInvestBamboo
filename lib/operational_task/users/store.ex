defmodule QuickInvest.Users.Store do
  use Agent
  @categories Application.compile_env!(:quick_invest, :allowed_categories)

  def start_link(_) do
    QuickInvest.Users.User.generate_users()
    |> Enum.reduce(%{}, &Map.put(&2, &1.id, &1))
    |> then(fn users_map -> fn -> users_map end end)
    |> Agent.start_link(name: __MODULE__)
  end

  def get_user(id), do: Agent.get(__MODULE__, &Map.get(&1, id))

  def get_by_category(cat) when cat in @categories do
    Agent.get(
      __MODULE__,
      &Enum.reduce(Map.values(&1), [], fn user, acc ->
        if user.preferred_category == cat, do: [user | acc], else: acc
      end)
    )
  end
end
