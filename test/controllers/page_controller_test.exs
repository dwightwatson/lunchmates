defmodule Lunchmates.PageControllerTest do
  use Lunchmates.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Lunchmates"
  end
end
