defmodule QuickInvest.Repo do
  use Ecto.Repo,
    otp_app: :quick_invest,
    adapter: Ecto.Adapters.Postgres
end
