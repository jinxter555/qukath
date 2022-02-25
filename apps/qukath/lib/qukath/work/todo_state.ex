defmodule Qukath.Work.TodoState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_states" do
    field :state, Ecto.Enum, values: [done: 100, notstarted: 101, started: 102, stopped: 103, aborted: 104, paused: 105], default: :notstarted
    field :approved, Ecto.Enum, values: [yes: 100, no: 101, wait: 103, rejected: 104], default: :wait
    field :todo_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo_state, attrs) do
    todo_state
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
