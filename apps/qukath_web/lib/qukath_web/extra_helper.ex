defmodule QukathWeb.ExtraHelper do

  def hide_deleted(changeset, css_class) do
    if changeset.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

  def merge_socket_assigns(socket, assigns) do
    Enum.reduce(Map.keys(assigns), socket, fn k, s ->
      Phoenix.LiveView.assign(s, k, assigns[k])
    end)
  end
end
