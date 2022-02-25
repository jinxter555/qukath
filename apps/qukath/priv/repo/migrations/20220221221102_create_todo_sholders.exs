defmodule Qukath.Repo.Migrations.CreateTodoSholders do
  use Ecto.Migration

  def change do
    create table(:todo_sholders) do
      add :todo_id, references(:todos, on_delete: :delete_all)
      add :owner_entity_id, references(:entities, on_delete: :nothing)
      add :assignto_entity_id, references(:entities, on_delete: :nothing)
      add :assignby_entity_id, references(:entities, on_delete: :nothing)
      add :notify_entity_id, references(:entities, on_delete: :nothing)
      add :approved_before_entity_id, references(:entities, on_delete: :nothing)
      add :approved_after_entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:todo_sholders, [:todo_id])
    create index(:todo_sholders, [:todo_id, :owner_entity_id])
    create index(:todo_sholders, [:todo_id, :assignto_entity_id])
  end
end
