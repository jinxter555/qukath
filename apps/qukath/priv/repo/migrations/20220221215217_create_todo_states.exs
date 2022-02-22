defmodule Qukath.Repo.Migrations.CreateTodoStates do
  use Ecto.Migration

  def change do
    create table(:todo_states) do
      add :state, :integer
      add :todo_id, references(:todos, on_delete: :nothing)

      timestamps()
    end

    create index(:todo_states, [:todo_id])
    create index(:todo_states, [:todo_id, :state])
  end
end
