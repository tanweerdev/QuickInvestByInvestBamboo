defmodule QuickInvest.Notifier.Email do
  require Logger
  import Swoosh.Email

  alias QuickInvest.Mailer
  alias QuickInvest.Events.Event
  alias QuickInvest.Users.Store, as: UserStore

  @behaviour QuickInvest.Notifier.Notifier
  @logger_prefix "[EmailNotifier] "

  def notify(%Event{enabled: true} = event) do
    Logger.info(@logger_prefix <> " Notifying event: #{inspect(event)}")

    event
    |> build_recipients()
    |> Enum.each(fn user ->
      new()
      |> to(user)
      |> from({"test", "test@gmail.com"})
      |> subject("New Company Alert!")
      |> text_body(build_message(event, user))
      |> Mailer.deliver()
    end)
  end

  def notify(_), do: :ok

  defp build_recipients(%Event{category: category}) do
    category
    |> UserStore.get_by_category()
    |> Enum.map(fn user -> {user.name, user.email} end)
  end

  defp build_message(
         %Event{company_name: company_name, category: category},
         {name, _email} = _user
       ) do
    category =
      category
      |> Atom.to_string()
      |> String.capitalize()

    """
    Hello #{name}!

    #{company_name} just got listed in #{category}.

    Happy Trading :)
    """
  end
end
