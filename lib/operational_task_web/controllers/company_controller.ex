defmodule QuickInvestWeb.CompanyController do
  use QuickInvestWeb, :controller

  alias QuickInvest.Events.Store, as: EventStore

  action_fallback(QuickInvestWeb.FallbackController)

  def index(conn, filters) do
    render(conn, :index, companies: EventStore.list(filters))
  end
end
