defmodule Lunchmates.LayoutView do
  use Lunchmates.Web, :view

  def active_class(conn, path, class \\ "active") do
    current_path = Path.join(["/" | conn.path_info])
    if path == current_path do
      class
    end
  end
end
