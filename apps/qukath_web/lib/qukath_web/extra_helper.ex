defmodule QukathWeb.ExtraHelper do

  def hide_deleted(changeset, css_class) do
    if changeset.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end
end
