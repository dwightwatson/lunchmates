defmodule Lunchmates.Auth do
  import Plug.Conn
  import Phoenix.Controller
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  alias Lunchmates.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        assign(conn, :current_user, user)

      user = user_id && repo.get(User, user_id) ->
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end

  def attempt(conn, %{"email" => email, "password" => password}, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, email: String.downcase(email))

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized, conn}

      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page.")
      |> redirect(to: Lunchmates.Router.Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  def guest(conn, _opts) do
    unless conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged out to access that page.")
      |> redirect(to: Lunchmates.Router.Helpers.page_path(conn, :index))
      |> halt()
    end
  end

  # def current_user(conn) do
  #   id = get_session(conn, :current_user)
  #   if id, do: Lunchmates.Repo.get(User, id)
  # end

  # def logged_in?(conn), do: !!current_user(conn)
end
