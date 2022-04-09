defmodule Qukath.Repo.Migrations.CreateSkills do
  use Ecto.Migration

  def change do
    create table(:skills) do
      add :role_id, references(:roles, on_delete: :delete_all)
      add :permit_id, references(:permits, on_delete: :delete_all)

      timestamps()
    end

    create index(:skills, [:role_id])
    create index(:skills, [:permit_id])
  end
end
