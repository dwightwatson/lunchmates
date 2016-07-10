defmodule Lunchmates.LocationControllerTest do
  use Lunchmates.ConnCase

  alias Lunchmates.Location
  @valid_attrs %{name: "KFC", description: "Finger lickin' good"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} = config do
    if config[:login] do
      user = insert_user()
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires user authentication on all modifying actions", %{conn: conn} do
    Enum.each([
      get(conn, location_path(conn, :new)),
      get(conn, location_path(conn, :edit, "123")),
      put(conn, location_path(conn, :update, "123", %{})),
      post(conn, location_path(conn, :create, %{})),
      delete(conn, location_path(conn, :delete, "123"))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag :login
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, location_path(conn, :index)
    assert html_response(conn, 200) =~ "All locations"
  end

  @tag :login
  test "renders form for new location", %{conn: conn} do
    conn = get conn, location_path(conn, :new)
    assert html_response(conn, 200) =~ "New location"
  end

  @tag :login
  test "creates location and redirects when data is valid", %{conn: conn, user: user} do
    conn = post conn, location_path(conn, :create), location: @valid_attrs
    assert redirected_to(conn) == location_path(conn, :index)
    assert Repo.get_by(Location, @valid_attrs).user_id == user.id
  end

  @tag :login
  test "does not create location and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, location_path(conn, :create), location: @invalid_attrs
    assert html_response(conn, 200) =~ "New location"
  end

  @tag :login
  test "shows chosen location", %{conn: conn} do
    location = insert_user() |> insert_location(@valid_attrs)
    conn = get conn, location_path(conn, :show, location)
    assert html_response(conn, 200) =~ location.name
  end

  @tag :login
  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, location_path(conn, :show, -1)
    end
  end

  @tag :login
  test "renders form for editing owned location", %{conn: conn, user: user} do
    location = insert_location(user, @valid_attrs)
    conn = get conn, location_path(conn, :edit, location)
    assert html_response(conn, 200) =~ "Edit location"
  end

  @tag :login
  test "renders page not found when editing unowned location", %{conn: conn} do
    location = insert_user() |> insert_location(@valid_attrs)
    assert_error_sent 404, fn ->
      get conn, location_path(conn, :edit, location)
    end
  end

  @tag :login
  test "updates chosen resource and redirects when data is valid", %{conn: conn, user: user} do
    location = insert_location(user, @valid_attrs)
    conn = put conn, location_path(conn, :update, location), location: @valid_attrs
    assert redirected_to(conn) == location_path(conn, :show, location)
    assert Repo.get_by(Location, @valid_attrs)
  end

  @tag :login
  test "does not update owned location and renders errors when data is invalid", %{conn: conn, user: user} do
    location = insert_location(user, @valid_attrs)
    conn = put conn, location_path(conn, :update, location), location: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit location"
  end

  @tag :login
  test "does not update unowned location and renders page not found", %{conn: conn} do
    location = insert_user() |> insert_location(@valid_attrs)
    assert_error_sent 404, fn ->
      put conn, location_path(conn, :update, location), location: @valid_attrs
    end
  end

  @tag :login
  test "deletes chosen owned location", %{conn: conn, user: user} do
    location = insert_location(user, @valid_attrs)
    conn = delete conn, location_path(conn, :delete, location)
    assert redirected_to(conn) == location_path(conn, :index)
    refute Repo.get(Location, location.id)
  end

  @tag :login
  test "does not delete unowned location", %{conn: conn} do
    location = insert_user() |> insert_location(@valid_attrs)
    assert_error_sent 404, fn ->
      delete conn, location_path(conn, :delete, location)
    end
  end
end
