defmodule QuickInvestWeb.CompanyJSON do
  alias QuickInvest.Events.Event

  @doc """
  Renders a list of companies.
  """
  def index(%{companies: companies}) do
    %{data: for(company <- companies, do: data(company))}
  end

  defp data(%Event{company_name: name, category: category, enabled: enabled?}) do
    %{
      name: name,
      category: category,
      enabled: enabled?
    }
  end
end
