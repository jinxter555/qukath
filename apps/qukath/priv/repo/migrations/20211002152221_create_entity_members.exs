defmodule Qujump.Repo.Migrations.CreateEntityMembers do
  use Ecto.Migration

  def change do
    create table(:entity_members) do
      add :entity_id,  references(:entities, on_delete: :nothing)
      add :member_id,  references(:entities, on_delete: :nothing)
      timestamps()
    end

    create index(:entity_members, [:entity_id])
    create index(:entity_members, [:entity_id, :member_id], unique: true)
  end
end
