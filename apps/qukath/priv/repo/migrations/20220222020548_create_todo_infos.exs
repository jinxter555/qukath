defmodule Qukath.Repo.Migrations.CreateTodoInfos do
  use Ecto.Migration

  def change do
    create table(:todo_infos) do
      add :name, :string
      add :description, :string
      add :dependency, :string
      add :priority, :integer, default: 1
      add :required_approval, :boolean
      add :todo_id, references(:todos, on_delete: :delete_all)

      timestamps()
    end

    create index(:todo_infos, [:todo_id])
  end
end
