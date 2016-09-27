defmodule Lunchmates.LunchChannel do
  use Lunchmates.Web, :channel
  alias Lunchmates.Presence

  def join("lunch:lobby", _, socket) do
    send(self, :after_join)

    user = Lunchmates.Repo.get!(Lunchmates.User, socket.assigns.user_id)

    {:ok, assign(socket, :user, user)}
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)

    {:ok, _ } = Presence.track(socket, socket.assigns.user.id, %{
      name: socket.assigns.user.name,
      online_at: inspect(System.system_time(:seconds))
    })

    {:noreply, socket}
  end
end
