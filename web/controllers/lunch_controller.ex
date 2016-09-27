defmodule Lunchmates.LunchController do
  use Lunchmates.Web, :controller

  alias Lunchmates.Lunch

  plug :authenticate

  def index(conn, _params) do
    lunches = Repo.all(Lunch)

    render(conn, "index.html", lunches: lunches)
  end

  def show(conn, %{"id" => id}) do
    lunch = Repo.get!(Lunch, id)

    render(conn, "show.html", lunch: lunch)
  end
end
