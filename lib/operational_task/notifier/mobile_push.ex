defmodule QuickInvest.Notifier.MobilePush do
  require Logger

  alias QuickInvest.Events.Event
  alias QuickInvest.Users.Store, as: UserStore

  @behaviour QuickInvest.Notifier.Notifier
  @endpoint QuickInvestWeb.Endpoint
  @logger_prefix "[MobilePushNotifier] "
  @event_name "New Company Listing !"

  def notify(%Event{enabled: true, category: category} = event) do
    Logger.info(@logger_prefix <> " Notifying event: #{inspect(event)}")

    category
    |> UserStore.get_by_category()
    |> Enum.each(fn user ->
      message = build_message(event, user)
      @endpoint.broadcast("user-#{user.id}", @event_name, message)
    end)
  end

  def notify(_), do: :ok

  defp build_message(
         %Event{company_name: company_name, category: category},
         %{name: name} = _user
       ) do
    """
    Hello #{name} !

    #{company_name} just got listed in #{category}.

    Happy Trading :)
    """
  end
end
