defmodule Qukath.Resources.Permit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Qukath.Resources.Resource

  schema "permits" do
    field :verb, :string
    #field :resource_id, :id
    belongs_to :resource, Resource

    timestamps()
  end

  @doc false
  def changeset(permit, attrs) do
    permit
    |> cast(attrs, [:verb, :resource_id])
    |> validate_required([:verb, :resource_id])
  end
end
