defmodule Qukath.Entities do
  @moduledoc """
  The Entities context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Entities.Entity

  @doc """
  Returns the list of entities.

  ## Examples

      iex> list_entities()
      [%Entity{}, ...]

  """
  def list_entities do
    Repo.all(Entity)
  end

  @doc """
  Gets a single entity.

  Raises `Ecto.NoResultsError` if the Entity does not exist.

  ## Examples

      iex> get_entity!(123)
      %Entity{}

      iex> get_entity!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entity!(id), do: Repo.get!(Entity, id)

  def get_entity_parent(entity_id) do
    e = get_entity!(entity_id)
    get_entity!(e.parent_id)
  end

  @doc """
  Creates a entity.

  ## Examples

      iex> create_entity(%{type: [:employee|:org|:league|:team]})
      {:ok, %Entity{}}

      iex> create_entity(%{type: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entity(attrs \\ %{}) do
    %Entity{}
    |> Entity.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entity.

  ## Examples

      iex> update_entity(entity, %{field: new_value})
      {:ok, %Entity{}}

      iex> update_entity(entity, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entity(%Entity{} = entity, attrs) do
    entity
    |> Entity.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entity.

  ## Examples

      iex> delete_entity(entity)
      {:ok, %Entity{}}

      iex> delete_entity(entity)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entity(%Entity{} = entity) do
    Repo.delete(entity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entity changes.

  ## Examples

      iex> change_entity(entity)
      %Ecto.Changeset{data: %Entity{}}

  """
  def change_entity(%Entity{} = entity, attrs \\ %{}) do
    Entity.changeset(entity, attrs)
  end

  alias Qukath.Entities.EntityMember

  @doc """
  Returns the list of entity_members.

  ## Examples

      iex> list_entity_members()
      [%EntityMember{}, ...]

  """
  def list_entity_members do
    Repo.all(EntityMember)
  end

  def list_entity_members(entity_id) do
    query = from em in EntityMember, where: em.entity_id == ^entity_id, select: em
    Repo.all(query)
  end

  def list_entity_children(entity_id) do
    query = from e in Entity, where: e.parent_id == ^entity_id, select: e
    Repo.all(query)
  end


  @doc """
  Gets a single entity_member.

  Raises `Ecto.NoResultsError` if the Entity member does not exist.

  ## Examples

      iex> get_entity_member!(123)
      %EntityMember{}

      iex> get_entity_member!(456)
      ** (Ecto.NoResultsError)

  """
  def get_entity_member!(id), do: Repo.get!(EntityMember, id)

  @doc """
  Creates a entity_member.

  ## Examples

      iex> create_entity_member(%{field: value})
      {:ok, %EntityMember{}}

      iex> create_entity_member(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_entity_member(attrs \\ %{}) do
    %EntityMember{}
    |> EntityMember.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a entity_member.

  ## Examples

      iex> update_entity_member(entity_member, %{field: new_value})
      {:ok, %EntityMember{}}

      iex> update_entity_member(entity_member, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_entity_member(%EntityMember{} = entity_member, attrs) do
    entity_member
    |> EntityMember.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a entity_member.

  ## Examples

      iex> delete_entity_member(entity_member)
      {:ok, %EntityMember{}}

      iex> delete_entity_member(entity_member)
      {:error, %Ecto.Changeset{}}

  """
  def delete_entity_member(%EntityMember{} = entity_member) do
    Repo.delete(entity_member)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entity_member changes.

  ## Examples

      iex> change_entity_member(entity_member)
      %Ecto.Changeset{data: %EntityMember{}}

  """
  def change_entity_member(%EntityMember{} = entity_member, attrs \\ %{}) do
    EntityMember.changeset(entity_member, attrs)
  end
  
  def nested_children(id) do

    entity_tree_initial_query = Entity
    |> where([e], e.id == ^id)
  
    entity_tree_recursion_query = Entity
    |> join(:inner, [e], t in "tree", on: t.id == e.parent_id)
  
    entity_tree_query = entity_tree_initial_query
    |> union_all(^entity_tree_recursion_query)

    #entity_tree_recursion_query
    #entity_tree_initial_query
    
    entity_tree_query
    |> recursive_ctes(true)
    |> with_cte("tree", as: ^entity_tree_query)
    # |> join(:left, [], t in "tree", on: t.id == ^id)
    |> Repo.all()

  end
end
