defmodule Qukath.Work.TodoSholder do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_sholders" do

    field :todo_id, :id
    field :owner_entity_id, :id
    field :assignto_entity_id, :id
    field :assignby_entity_id, :id
    field :notify_entity_id, :id
    field :approved_before_entity_id, :id
    field :approved_after_entity_id, :id


    timestamps()
  end

  @doc false
  def changeset(todo_sholder, attrs) do
    todo_sholder
    |> cast(attrs, [:todo_id, :owner_entity_id])
    |> validate_required([:todo_id, :owner_entity_id])
  end
end
