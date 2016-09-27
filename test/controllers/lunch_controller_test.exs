defmodule Lunchmates.LunchControllerTest do
  use Lunchmates.ConnCase

  alias Lunchmates.Lunch
  @valid_attrs %{date: %{day: 1, month: 1, year: 2000}}
  @invalid_attrs %{date: nil}

  setup %{conn: conn} = config do
    if config[:login] do
      user = insert_user()
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires user authentication on actions", %{conn: conn} do
    Enum.each([
      get(conn, lunch_path(conn, :index)),
      get(conn, lunch_path(conn, :show, "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag :login
  test "lists all lunches on index", %{conn: conn} do
    conn = get conn, lunch_path(conn, :index)
    assert html_response(conn, 200) =~ "All lunches"
  end

  @tag :login
  test "shows chosen lunch", %{conn: conn} do
    lunch = Lunch.changeset(%Lunch{}, @valid_attrs) |> Repo.insert!
    conn = get conn, lunch_path(conn, :show, lunch)
    assert html_response(conn, 200) =~ to_string(lunch.date)
  end

  @tag :login
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, lunch_path(conn, :show, -1)
    end
  end
end
