defmodule Qukath.Resources do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo
  alias Qukath.Entities
  alias Qukath.Resources.Resource

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resources do
    Repo.all(Resource)
  end

  def list_resources(%{"orgstruct_id" => orgstruct_id}), do:
      list_resources(orgstruct_id: orgstruct_id)

  def list_resources(orgstruct_id: orgstruct_id) do
    query = from r in Resource,
      where: r.orgstruct_id == ^orgstruct_id,
      select: r
    Repo.all(query) 
  end



  @doc """
  Gets a single resource.

  Raises `Ecto.NoResultsError` if the Resource does not exist.

  ## Examples

      iex> get_resource!(123)
      %Resource{}

      iex> get_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource!(id), do: Repo.get!(Resource, id)

  @doc """
  Creates a resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :resource}),
        {:ok, resource} <- %Resource{entity: entity} |> Resource.changeset(attrs) |> Repo.insert() 
      do
        {:ok, resource}
      else
        {:error, error} -> Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} ->
        broadcast(result, :resource_created)
        result
      error -> error
    end
  end

  @doc """
  Updates a resource.

  ## Examples

      iex> update_resource(resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
    |> broadcast(:resource_updated)

  end

  @doc """
  Deletes a resource.

  ## Examples

      iex> delete_resource(resource)
      {:ok, %Resource{}}

      iex> delete_resource(resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.transaction(fn ->
       entity_id = resource.entity_id
       resource_changeset = Repo.delete(resource)
       Entities.get_entity!(entity_id) |> Entities.delete_entity()
       resource_changeset
     end) |> case do
      {:ok,  result} -> 
        broadcast(result, :resource_deleted)
        result
     end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Examples

      iex> change_resource(resource)
      %Ecto.Changeset{data: %Resource{}}

  """
  def change_resource(%Resource{} = resource, attrs \\ %{}) do
    Resource.changeset(resource, attrs)
  end


   #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "resources")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, resource}, event) do
    Phoenix.PubSub.broadcast(Qukath.PubSub, "resources", {event, resource})
    {:ok, resource}
  end

end
