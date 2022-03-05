defmodule Qukath.Roles do
  @moduledoc """
  The Role context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Roles.Role
  alias Qukath.Entities

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles do
    Repo.all(Role)
  end

  def list_roles(%{"orgstruct_id" => orgstruct_id}), do:
      list_roles(orgstruct_id: orgstruct_id)

  def list_roles(orgstruct_id: orgstruct_id) do
    query = from r in Role,
      where: r.orgstruct_id == ^orgstruct_id,
      select: r
    Repo.all(query) 
  end


  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role info does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    IO.puts "create_role"
    IO.inspect attrs
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :role}),
        {:ok, role} <- %Role{entity: entity} |> Role.changeset(attrs) |> Repo.insert() 
      do
        {:ok, role}
      else
        {:error, error} -> Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} ->
        broadcast(result, :role_created)
        result
      error -> error
    end

  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
    |> broadcast(:role_updated)

  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
     Repo.transaction(fn ->
       entity_id = role.entity_id
       role_changeset = Repo.delete(role)
       Entities.get_entity!(entity_id) |> Entities.delete_entity()
       role_changeset
     end) |> case do
      {:ok,  result} -> 
        broadcast(result, :role_deleted)
        result
     end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "roles")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, role}, event) do
    Phoenix.PubSub.broadcast(Qukath.PubSub, "roles", {event, role})
    {:ok, role}
  end


end
