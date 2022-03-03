defmodule Qukath.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :name, :string
      add :entity_id, references(:entities, on_delete: :delete_all)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)

      timestamps()
    end

    create index(:roles, [:name])
    create index(:roles, [:entity_id])
    create index(:roles, [:orgstruct_id])
    create index(:roles, [:orgstruct_id, :name])
  end
end
