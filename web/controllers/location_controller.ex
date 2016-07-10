defmodule Lunchmates.LocationController do
  use Lunchmates.Web, :controller

  alias Lunchmates.Location

  plug :authenticate when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    locations = Location
    |> Location.alphabetical
    |> preload(:user)
    |> Repo.all

    render(conn, "index.html", locations: locations)
  end

  def new(conn, _params) do
    changeset = conn.assigns.current_user
    |> build_assoc(:locations)
    |> Location.changeset()

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"location" => location_params}) do
    changeset = conn.assigns.current_user
    |> build_assoc(:locations)
    |> Location.changeset(location_params)

    case Repo.insert(changeset) do
      {:ok, _location} ->
        conn
        |> put_flash(:info, "Location created successfully.")
        |> redirect(to: location_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    location = Location
    |> preload(:user)
    |> Repo.get!(id)

    render(conn, "show.html", location: location)
  end

  def edit(conn, %{"id" => id}) do
    # location = current_user(conn)
    location = conn.assigns.current_user
    |> user_locations
    |> Repo.get!(id)

    changeset = Location.changeset(location)
    render(conn, "edit.html", location: location, changeset: changeset)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = conn.assigns.current_user
    |> user_locations
    |> Repo.get!(id)

    changeset = Location.changeset(location, location_params)

    case Repo.update(changeset) do
      {:ok, location} ->
        conn
        |> put_flash(:info, "Location updated successfully.")
        |> redirect(to: location_path(conn, :show, location))
      {:error, changeset} ->
        render(conn, "edit.html", location: location, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = conn.assigns.current_user
    |> user_locations
    |> Repo.get!(id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(location)

    conn
    |> put_flash(:info, "Location deleted successfully.")
    |> redirect(to: location_path(conn, :index))
  end

  defp user_locations(user) do
    assoc(user, :locations)
  end
end
