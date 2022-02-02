defmodule Qukath.Repo.Migrations.CreateOrgstructs do
  use Ecto.Migration

  def change do
    create table(:orgstructs) do
      add :name, :string
      add :type, :integer
      add :leader_entity_id, references(:entities, on_delete: :nothing)
      add :entity_id, references(:entities, on_delete: :delete_all)

      timestamps()
    end

    create index(:orgstructs, [:leader_entity_id])
    create index(:orgstructs, [:entity_id])
  end
end
