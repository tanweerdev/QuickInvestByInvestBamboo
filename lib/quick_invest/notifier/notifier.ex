defmodule QuickInvest.Notifier.Notifier do
  @moduledoc """
  Behaviour for notifiers to implement
  """

  @doc """
  Main API exposed by each notifier module
  """
  @callback notify(event :: map()) :: :ok
end
