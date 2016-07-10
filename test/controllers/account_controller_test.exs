defmodule Lunchmates.AccountControllerTest do
  use Lunchmates.ConnCase

  alias Lunchmates.User
  @valid_attrs %{name: "John Doe", email: "john@example.com"}
  @invalid_attrs %{name: "", email: ""}

  setup %{conn: conn} = config do
    if config[:login] do
      user = insert_user()
      conn = assign(conn, :current_user, user)
      {:ok, conn: conn, user: user}
    else
      :ok
    end
  end

  test "requires user authentication on all actions", %{conn: conn} do
    Enum.each([
      get(conn, account_path(conn, :index)),
      put(conn, account_path(conn, :update, %{})),
      delete(conn, account_path(conn, :delete))
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  @tag :login
  test "renders form for editing account", %{conn: conn, user: user} do
    conn = get conn, account_path(conn, :index)
    assert html_response(conn, 200) =~ user.name
  end

  @tag :login
  test "updates account and redirects when data is valid", %{conn: conn, user: user} do
    conn = put conn, account_path(conn, :update), user: @valid_attrs
    assert redirected_to(conn) == user_path(conn, :show, user)
    assert Repo.get_by(User, @valid_attrs)
  end

  @tag :login
  test "does not update account and renders errors when data is invalid", %{conn: conn} do
    conn = put conn, account_path(conn, :update), user: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit account"
  end

  @tag :login
  test "deletes account", %{conn: conn, user: user} do
    conn = delete conn, account_path(conn, :delete)
    assert redirected_to(conn) == page_path(conn, :index)
    refute Repo.get(User, user.id)
  end
end

