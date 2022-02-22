defmodule Qukath.Work.TodoState do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todo_states" do
    field :state, Ecto.Enum, values: [done_appoved: 100, done: 101, notstated: 102, started: 103, stopped: 104, aborted: 105, paused: 106]
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
