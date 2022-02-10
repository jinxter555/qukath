defmodule Qukath.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :type, :integer
      add :state, :integer
      add :description, :string
      add :entity_id, references(:entities, on_delete: :nothing)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)
      add :owner_entity_id, references(:entities, on_delete: :nothing)
      add :assignby_entity_id, references(:entities, on_delete: :nothing)
      add :assignto_entity_id, references(:entities, on_delete: :nothing)

      timestamps()
    end

    create index(:todos, [:entity_id])
    create index(:todos, [:owner_entity_id])
    create index(:todos, [:description])
    create index(:todos, [:assignby_entity_id])
    create index(:todos, [:assignto_entity_id])
  end
end
