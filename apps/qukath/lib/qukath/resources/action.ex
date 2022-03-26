defmodule Qukath.Resources.Action do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Resources.Resource

  schema "actions" do
    field :verb, :string
    #field :resource_id, :id
    belongs_to :resource, Resource

    timestamps()
  end

  @doc false
  def changeset(action, attrs) do
    action
    |> cast(attrs, [:verb, :resource_id])
    |> validate_required([:verb, :resource_id])
  end
end
