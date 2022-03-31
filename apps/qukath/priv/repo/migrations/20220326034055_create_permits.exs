defmodule Qukath.Repo.Migrations.CreatePermits do
  use Ecto.Migration

  def change do
    create table(:permits) do
      add :verb, :string
      add :resource_id, references(:resources,  on_delete: :delete_all)

      timestamps()
    end

    create index(:permits, [:resource_id])
  end
end
