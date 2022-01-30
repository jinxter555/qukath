defmodule Qukath.Repo.Migrations.CreateEmployees do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)
      add :entity_id, references(:entities, on_delete: :nothing)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)

      timestamps()
    end

    create index(:employees, [:name])
    create index(:employees, [:user_id])
    create index(:employees, [:entity_id])
  end
end
