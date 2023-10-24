defmodule QuickInvestWeb.NotificationSocket do
  use Phoenix.Socket
  alias QuickInvest.Users.Store, as: UserStore

  channel("notification:lobby", QuickInvestWeb.NotificationChannel)

  @impl true
  @spec connect(map, any, any) :: {:error, <<_::64, _::_*8>>} | {:ok, Phoenix.Socket.t()}
  def connect(%{"token" => _token, "id" => id}, socket, _connect_info) do
    case UserStore.get_user(id) do
      nil -> {:error, "No user registered against this id: #{id}"}
      {:ok, user} -> {:ok, assign(socket, current_user: user)}
    end
  end

  @impl true
  def id(socket), do: "user-#{socket.assigns.current_user.id}"
end
