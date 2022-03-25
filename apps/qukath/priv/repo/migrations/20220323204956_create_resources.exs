defmodule Qukath.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :name, :string
      add :entity_id, references(:entities, on_delete: :delete_all)
      add :owner_id, references(:entities, on_delete: :nothing)
      add :orgstruct_id, references(:orgstructs, on_delete: :nothing)

      timestamps()
    end

    create index(:resources, [:entity_id])
    create index(:resources, [:name])
    create index(:resources, [:owner_id])
    create index(:resources, [:orgstruct_id])
  end
end
