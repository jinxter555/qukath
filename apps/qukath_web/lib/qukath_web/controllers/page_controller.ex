defmodule QukathWeb.PageController do
  use QukathWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
