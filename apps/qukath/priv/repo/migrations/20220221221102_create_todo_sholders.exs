defmodule Qukath.Repo.Migrations.CreateTodoSholders do
  use Ecto.Migration

  def change do
    create table(:todo_sholders) do
      add :todo_id, references(:todos, on_delete: :delete_all)
      add :entity_id, references(:entities, on_delete: :nothing)
      add :type, :integer
      add :approved, :integer

      timestamps()
    end

    create index(:todo_sholders, [:todo_id])
    create index(:todo_sholders, [:todo_id, :entity_id])
    create index(:todo_sholders, [:todo_id, :entity_id, :type])
  end
end
