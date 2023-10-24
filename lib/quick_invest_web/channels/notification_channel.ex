defmodule QuickInvestWeb.NotificationChannel do
  use QuickInvestWeb, :channel

  @impl true
  def join("notification:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(_) do
    true
  end
end
