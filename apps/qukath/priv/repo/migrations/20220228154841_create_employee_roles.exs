defmodule Qukath.Repo.Migrations.CreateEmployeeRoles do
  use Ecto.Migration

  def change do
    create table(:employee_roles) do
      add :entity_id, references(:entities, on_delete: :nothing)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)
      add :employee_id, references(:employees, on_delete: :nothing)
      add :role_id, references(:roles, on_delete: :nothing)

      timestamps()
    end

    create index(:employee_roles, [:entity_id])
    create index(:employee_roles, [:orgstruct_id])
    create index(:employee_roles, [:employee_id])
    create index(:employee_roles, [:role_id])
    create unique_index(:employee_roles, [:employee_id, :role_id])
  end
end
