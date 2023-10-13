defmodule QuickInvest.Users.User do
  use Ecto.Schema

  @users_count 25
  @categories Application.compile_env!(:quick_invest, :allowed_categories)

  @type t :: %__MODULE__{
          name: String.t(),
          preferred_category: atom(),
          email: String.t()
        }

  embedded_schema do
    field(:name, :string)
    field(:preferred_category, Ecto.Enum, values: @categories)
    field(:email, :string)
  end

  @spec generate_users :: list(t())
  def generate_users() do
    Enum.map(1..@users_count, fn id ->
      %__MODULE__{
        id: id,
        name: Faker.Company.En.name(),
        preferred_category: Enum.random(@categories),
        email: Faker.Internet.email()
      }
    end)
  end
end
