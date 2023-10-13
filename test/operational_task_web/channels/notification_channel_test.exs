defmodule QuickInvestWeb.NotificationChannelTest do
  use QuickInvestWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      QuickInvestWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(QuickInvestWeb.NotificationChannel, "notification:lobby")

    %{socket: socket}
  end

  # todo: test is broadcast is working
  # test "websocket", %{socket: socket} do
  #   ref = push(socket, "ping", %{"hello" => "there", "token" => "some_signed_token"})
  #   assert_reply(ref, :ok, %{"hello" => "there", "token" => "some_signed_token"})
  # end
end
