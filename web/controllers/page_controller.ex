defmodule Lunchmates.PageController do
  use Lunchmates.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
