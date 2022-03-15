defmodule Qukath.Work.TodoSholder do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Entities.Entity

  schema "todo_sholders" do

    field :todo_id, :id
    field :approved, Ecto.Enum, values: [yes: 100, no: 101, wait: 103, rejected: 104], default: :wait
    field :type , Ecto.Enum, values: [owner: 100, createdby: 101, assignedto: 102, assignedby: 103, notify: 104, approved_before: 105, approved_after: 106], default: :owner
    belongs_to :entity, Entity


    timestamps()
  end

  @doc false
  def changeset(todo_sholder, attrs) do
    todo_sholder
    |> cast(attrs, [:todo_id, :approved, :type])
    |> validate_required([:todo_id, :approved, :type])
  end
end
