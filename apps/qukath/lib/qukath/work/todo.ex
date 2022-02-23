defmodule Qukath.Work.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Qukath.Entities.Entity
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Work.{TodoInfo, TodoSholder, TodoState}

  schema "todos" do
    field :type, Ecto.Enum, values: [task: 100, list: 101, project: 102, program: 103]

    field :description, :string,  virtual: true
    field :name, :string,  virtual: true


    belongs_to :entity, Entity
    belongs_to :orgstruct, Orgstruct

    has_many :todo_infos, TodoInfo
    has_many :todo_states, TodoState
    has_many :todo_sholders, TodoSholder


    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:type, :orgstruct_id, :description, :name])
    |> validate_required([:type, :orgstruct_id, :description])
    |> cast_assoc(:entity)
    |> cast_assoc(:orgstruct)
  end
end
