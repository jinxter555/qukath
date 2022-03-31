defmodule Qukath.Repo.Migrations.CreateSkillsets do
  use Ecto.Migration

  def change do
    create table(:skillsets) do
      add :name, :string
      add :role_id, references(:roles,  on_delete: :delete_all)

      timestamps()
    end

    create index(:skillsets, [:name])
    create index(:skillsets, [:role_id])
  end
end
