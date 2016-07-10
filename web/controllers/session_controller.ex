defmodule Lunchmates.SessionController do
  use Lunchmates.Web, :controller

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => session_params}) do
    case Lunchmates.Auth.attempt(conn, session_params, repo: Lunchmates.Repo) do
      {:ok, user} ->
        conn
        |> Lunchmates.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))

      {:error, _, _} ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> Lunchmates.Auth.logout()
    |> put_flash(:info, "Until next time!")
    |> redirect(to: page_path(conn, :index))
  end
end
