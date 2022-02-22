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


  # alias Qukath.Entities.EntityMember
  alias Qukath.Entities.Entity



  @doc """
  Returns the list of orgstructs.

  ## Examples

      iex> list_orgstructs()
      [%Orgstruct{}, ...]

  """
  def list_orgstructs do
    Repo.all(Orgstruct)
  end

  def list_orgstructs("company"),
    do: list_orgstructs(type: "company")

  def list_orgstructs("corporate_group"),
    do: list_orgstructs(type: "corporate_group")

  def list_orgstructs(type: type) do
    query = from org in Orgstruct,
      where: org.type == ^type
    Repo.all(query)
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
        broadcast(result, :orgstruct_created, "orgstructs")
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
             %{"user_id" => user.id, "name" => username, "orgstruct_id" => orgstruct.id}) do
        {:ok, orgstruct}
      else
        error -> error
      end
    end) |> case do
      {:ok, result} -> 
        broadcast(result, :orgstruct_created, "orgstructs")
        result
    end
  end

  defp create_orgstruct_entity(attrs) do
    parent_entity_id = 
      if Map.has_key?(attrs, "orgstruct_id") do
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
    |> broadcast(:orgstruct_updated, "orgstructs")
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
        broadcast(result, :orgstruct_deleted, "orgstructs")
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

  #######
  def list_members(id) do
    orgstruct = get_orgstruct_with_members!(id)
    orgstruct.entity.members
  end

  def list_children(id) do
    orgstruct = get_orgstruct!(id)
    
    query = from org in Orgstruct,
     join: e in Entity, 
      on: e.id == org.entity_id,
      where: e.parent_id == ^orgstruct.entity_id

    Repo.all(query)
  end

  #######
  def print_org(orgstruct) do
    IO.inspect orgstruct.name
    IO.inspect orgstruct.id
     IO.inspect "id: " <> Integer.to_string(orgstruct.entity_id)
    if orgstruct.entity.parent_id, 
      do: IO.inspect "parent: " <> Integer.to_string(orgstruct.entity.parent_id)
    IO.puts ""
  end

  def print_nested(orgstruct) do
    print_org(orgstruct)
    for child <- orgstruct.children do
      if Map.has_key?(child, :children) do
        print_nested(child) 
      end
    end
  end

  #######
  def get_nested_orgstruct_by_id(orgstruct, id) do
    if orgstruct.id == id do
      orgstruct
    else
      Enum.find(orgstruct.children, fn child -> child.id == id end) 
      |> case do
      nil -> 
        Enum.find(orgstruct.children, fn child -> 
          found = get_nested_orgstruct_by_id(child, id)
          if found, do:
            found.id  == id,
          else:
            false
        end) 
      found -> found
      end
    end
  end


  #######
  def build_nested_orgstruct(orgstruct_id) do
    descents = list_descendants(orgstruct_id)
    nested(descents, nil)
  end

  defp nested([], _), do: []

  defp nested([head|_tail]=l, nil) do
    Map.put(head, :children, nested(l, head.entity_id))
  end

  defp nested([_head | tail] = _l, parent_id) do
    children = Enum.map(tail, fn x ->
      if x.entity.parent_id == parent_id, do:
      Map.put(x, :children, nested(tail, x.entity_id))
    end)

    children = Enum.filter(children, 
      fn child -> child != nil end) 

    children |> List.flatten
  end

  def list_descendants(orgstruct_id, :ids) do
    list_descendants(orgstruct_id) |> Enum.map(&(&1.id))
  end

  def list_descendants(orgstruct_id) do
    orgstruct = get_orgstruct!(orgstruct_id)

    entity_tree_initial_query = Entity
    |> where([e], e.id == ^orgstruct.entity_id)
  
    entity_tree_recursion_query = Entity
    |> join(:inner, [e], t in "tree", on: t.id == e.parent_id)
  
    entity_tree_query = entity_tree_initial_query
    |> union_all(^entity_tree_recursion_query)

    Orgstruct
    |> recursive_ctes(true)
    |> with_cte("tree", as: ^entity_tree_query)
    |> join(:inner, [o], t in "tree", on: t.id == o.entity_id)
    |> Repo.all()
    |> Repo.preload([entity: :parent])

  end

  #######
  def insert_orgstruct_member(orgstruct_id, employee_id) do
    employee_entity_id = Employees.get_employee_entity_id!(employee_id)
    orgstruct_entity_id = get_orgstruct_entity_id!(orgstruct_id)
    Entities.create_entity_member(%{
      entity_id: orgstruct_entity_id,
      member_id: employee_entity_id})
    |> broadcast(:orgstruct_member_inserted, "orgstruct_members")
  end

  def delete_orgstruct_member(orgstruct_id, employee_id) do
    orgstruct_entity_id = get_orgstruct_entity_id!(orgstruct_id)
    employee_entity_id = Employees.get_employee_entity_id!(employee_id)
    em = Entities.get_entity_member!(orgstruct_entity_id, employee_entity_id)
    Entities.delete_entity_member(em)
    |> broadcast(:orgstruct_member_deleted, "orgstruct_members")
  end


  #######
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "orgstructs")
  end

  def subscribe("orgstruct_members") do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "orgstruct_members")
  end

  defp broadcast({:error, _reason} = error, _event, _), do: error
  defp broadcast({:ok, orgstruct}, event, "orgstructs") do
    # IO.puts "broadcast"
    Phoenix.PubSub.broadcast(Qukath.PubSub, "orgstructs", {event, orgstruct})
    {:ok, orgstruct}
  end

  defp broadcast({:ok, em}, event, "orgstruct_members") do
    # IO.puts "broadcast"
    Phoenix.PubSub.broadcast(Qukath.PubSub, "orgstruct_members", {event, em})
    {:ok, em}
  end

end
