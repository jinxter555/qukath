defmodule Qukath.Work.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias Qukath.Entities.Entity
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Work.{TodoInfo, TodoSholder, TodoState}

  schema "todos" do
    field :description, :string
    field :state, Ecto.Enum, values: [default: 42, notstarted: 100, done: 101, started: 102, stopped: 103, aborted: 104, paused: 105]
    field :type, Ecto.Enum, values: [task: 100, list: 101, project: 102, program: 103]
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
    |> cast(attrs, [:type, :state, :orgstruct_id])
    |> validate_required([:type, :state,  :orgstruct_id])
    |> cast_assoc(:entity)
    |> cast_assoc(:orgstruct)
  end
end
