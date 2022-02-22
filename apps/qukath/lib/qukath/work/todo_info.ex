defmodule Qukath.Work.TodoInfo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_infos" do
    field :dependency, :string
    field :description, :string
    field :name, :string
    field :todo_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo_info, attrs) do
    todo_info
    |> cast(attrs, [:name, :description, :dependency])
    |> validate_required([:name, :description, :dependency])
  end
end
