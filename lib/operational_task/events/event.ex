defmodule QuickInvest.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset, only: [cast: 3, validate_required: 2, apply_changes: 1]
  alias QuickInvest.Events.Store, as: EventStore

  @fields ~w(company_name enabled category)a
  @required ~w(company_name)a
  @categories Application.compile_env!(:quick_invest, :allowed_categories)

  @type t :: %__MODULE__{
          company_name: String.t(),
          enabled: boolean(),
          category: String.t()
        }

  embedded_schema do
    field(:company_name, :string)
    field(:enabled, :boolean, default: true)
    field(:category, Ecto.Enum, values: @categories)
  end

  @spec build_struct(map()) :: {:ok, t()} | {:error, Ecto.Changeset.t()}
  def build_struct(params) do
    case changeset(%__MODULE__{}, params) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, apply_changes(changeset) |> Map.put(:id, EventStore.generate_id())}

      invalid_changeset ->
        {:error, invalid_changeset}
    end
  end

  defp changeset(%__MODULE__{} = struct, params) do
    struct
    |> cast(params, @fields)
    |> validate_required(@required)
  end
end
