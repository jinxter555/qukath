defmodule Qukath.Orgstructs do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Organizations.Orgstruct
  alias Qukath.Employees
  alias Qukath.Entities
  alias Qukath.Accounts

  @doc """
  Returns the list of orgstructs.

  ## Examples

      iex> list_orgstructs()
      [%Orgstruct{}, ...]

  """
  def list_orgstructs do
    Repo.all(Orgstruct)
  end

  @doc """
  Gets a single orgstruct.

  Raises `Ecto.NoResultsError` if the Orgstruct does not exist.

  ## Examples

      iex> get_orgstruct!(123)
      %Orgstruct{}

      iex> get_orgstruct!(456)
      ** (Ecto.NoResultsError)

  """
  def get_orgstruct!(id), do: Repo.get!(Orgstruct, id)

  def get_orgstruct_entity_id!(id) do
    o = get_orgstruct!(id)
    o.entity_id
  end

  def get_orgstruct_parent!(id) do
    parent_entity = get_orgstruct!(id) |> Repo.preload([entity: :parent])

    query = from org in Orgstruct,
      where: org.entity_id == ^parent_entity.id

    hd Repo.all(query)
  end

  def get_orgstruct_with_members!(id) do
    get_orgstruct!(id) |> Repo.preload([entity: :members])
  end


  @doc """
  Creates a orgstruct.

  ## Examples

      iex> create_orgstruct(%{field: value})
      {:ok, %Orgstruct{}}

      iex> create_orgstruct(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orgstruct(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, orgstruct_entity} <- create_orgstruct_entity(attrs),
           {:ok, orgstruct} <- create_orgstruct(orgstruct_entity.id, attrs) do

        {:ok, orgstruct}
      else
        error -> error
      end
    end) |> case do
      {:ok,  result} -> 
        broadcast(result, :orgstruct_created)
        result
    end
  end

  def create_orgstruct(entity_id, attrs) do
    attrs = Map.put(attrs, "entity_id", entity_id)
    %Orgstruct{}
    |> Orgstruct.changeset(attrs)
    |> Repo.insert()
  end

  def create_orgstruct_init(user_id, attrs \\ %{}, username \\ nil) do
    user = Accounts.get_user!(user_id)
    username = username  || hd(String.split(user.email, "@"))
    Repo.transaction(fn ->
      with {:ok, leader_entity} <- Entities.create_entity(%{type: :employee}),
           {:ok, orgstruct_entity} <- create_orgstruct_entity(attrs),

           attrs <- Map.put(attrs, "leader_entity_id", leader_entity.id),

           {:ok, orgstruct} <- create_orgstruct(orgstruct_entity.id, attrs),
           {:ok, _} <- Employees.create_employee(leader_entity.id, 
             %{user_id: user.id, name: username, orgstruct_id: orgstruct.id}) do
        {:ok, orgstruct}
      else
        error -> error
      end
    end) |> case do
      {:ok, result} -> 
        broadcast(result, :orgstruct_created)
        result
    end
  end

  defp create_orgstruct_entity(attrs) do
    parent_entity_id = 
      if attrs["orgstruct_id"] != "" do 
        get_orgstruct_entity_id!(attrs["orgstruct_id"])
      else 
        nil
      end
    Entities.create_entity(%{type: :org, parent_id: parent_entity_id})
  end


  @doc """
  Updates a orgstruct.

  ## Examples

      iex> update_orgstruct(orgstruct, %{field: new_value})
      {:ok, %Orgstruct{}}

      iex> update_orgstruct(orgstruct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orgstruct(%Orgstruct{} = orgstruct, attrs) do
    orgstruct
    |> Orgstruct.changeset(attrs)
    |> Repo.update()
    |> broadcast(:orgstruct_updated)
  end

  @doc """
  Deletes a orgstruct.

  ## Examples

      iex> delete_orgstruct(orgstruct)
      {:ok, %Orgstruct{}}

      iex> delete_orgstruct(orgstruct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orgstruct(%Orgstruct{} = orgstruct) do
    Repo.transaction(fn ->
      entity_id = orgstruct.entity_id
      orgstruct_changeset = Repo.delete(orgstruct)
      Entities.get_entity!(entity_id) |> Entities.delete_entity()
      orgstruct_changeset
    end) |> case do
      {:ok,  result} -> 
        broadcast(result, :orgstruct_deleted)
        result
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orgstruct changes.

  ## Examples

      iex> change_orgstruct(orgstruct)
      %Ecto.Changeset{data: %Orgstruct{}}

  """
  def change_orgstruct(%Orgstruct{} = orgstruct, attrs \\ %{}) do
    Orgstruct.changeset(orgstruct, attrs)
  end


  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "orgstructs")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, orgstruct}, event) do
    # IO.puts "broadcast"
    Phoenix.PubSub.broadcast(Qukath.PubSub, "orgstructs", {event, orgstruct})
    {:ok, orgstruct}
  end

end
