defmodule Lunchmates.AccountController do
  use Lunchmates.Web, :controller

  alias Lunchmates.User

  plug :authenticate

  def index(conn, _params) do
    user = conn.assigns.current_user
    changeset = User.changeset(user)
    render(conn, "index.html", user: user, changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    user = conn.assigns.current_user
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Account updated successfully.")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "index.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.current_user

    Repo.delete!(user)

    conn
    |> Lunchmates.Auth.logout()
    |> put_flash(:info, "Account deleted successfully.")
    |> redirect(to: page_path(conn, :index))
  end
end
