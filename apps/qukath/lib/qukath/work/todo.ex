defmodule Qukath.Work.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Qukath.Entities.Entity
  alias Qukath.Organizations.Orgstruct

  schema "todos" do
    field :description, :string
    field :state, :integer
    field :type, Ecto.Enum, values: [task: 100, list: 101, project: 102, program: 103]
    belongs_to :entity, Entity
    belongs_to :orgstruct, Orgstruct
    belongs_to :owner_entity, Entity, on_replace: :update
    belongs_to :assignby_entity, Entity, on_replace: :update
    belongs_to :assignto_entity, Entity, on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:type, :state, :description])
    |> validate_required([:type, :state, :description])
    |> cast_assoc(:entity)
    |> cast_assoc(:owner_entity)
    |> cast_assoc(:assignto_entity)
    |> cast_assoc(:assignby_entity)
    |> cast_assoc(:orgstruct)
  end
end
