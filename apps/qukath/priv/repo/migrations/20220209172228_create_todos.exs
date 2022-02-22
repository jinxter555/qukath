defmodule Qukath.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :type, :integer
      add :entity_id, references(:entities, on_delete: :nothing)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)

      timestamps()
    end

    create index(:todos, [:orgstruct_id])
    create index(:todos, [:orgstruct_id, :type])
  end
end
