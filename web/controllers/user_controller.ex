defmodule Lunchmates.UserController do
  use Lunchmates.Web, :controller

  alias Lunchmates.User

  plug :guest when action in [:new, :create]
  plug :authenticate when action in [:index, :show]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.create_changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.create_changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Lunchmates.Auth.login(user)
        |> put_flash(:info, "Welcome, I hope you're hungry!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:info, "Whoops, something went wrong.")
        |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User
    |> preload(:locations)
    |> Repo.get!(id)
    # user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end
end
