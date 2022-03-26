defmodule Qukath.Repo.Migrations.CreateActions do
  use Ecto.Migration

  def change do
    create table(:actions) do
      add :verb, :string
      add :resource_id, references(:resources,  on_delete: :delete_all)

      timestamps()
    end

    create index(:actions, [:resource_id])
  end
end
