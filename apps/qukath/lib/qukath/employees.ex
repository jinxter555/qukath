defmodule Qukath.Employees do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo
  alias Qukath.Entities
  #alias Qukath.Entities.Entity
  alias Qukath.Entities.EntityMember

  alias Qukath.Orgstructs
  alias Qukath.Organizations.Employee

  @doc """
  Returns the list of employees.

  ## Examples

      iex> list_employees()
      [%Employee{}, ...]

  """
  def list_employees do
    Repo.all(Employee)
  end

  #########
  def list_employees(%{"orgstruct_id" =>  orgstruct_id, "except_ids" => except_ids} = params) do
    query = from emp in Employee,
      where: emp.orgstruct_id == ^orgstruct_id
      and emp.id not in ^except_ids,
      select: emp
    if params["page"], do: query |> Repo.paginate(params),
    else: Repo.all(query)
  end

  #########
  def list_employees(%{"orgstruct_id" => orgstruct_id} = params) do
    query = from emp in Employee,
      where: emp.orgstruct_id == ^orgstruct_id,
      select: emp

    if params["page"], do: query |> Repo.paginate(params),
    else: Repo.all(query)
  end


  #########
  def list_employees(%{"page" => _page} = params) do
    Employee
    |> Repo.paginate(params)
  end

  
  @doc """
  Returns the list of employees based on orgstruct_id.

  
  @doc """
  Returns the list of employees based on orgstruct_id.
  ## Examples

      iex> list_employee_members(:orgstruct_id: orgstruct_id)
      # [%Employee{}, ...]

  """
  def list_employee_members(%{"orgstruct_id" => orgstruct_id, "except_orgstruct_id" => except_orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
    except_orgstruct = Orgstructs.get_orgstruct!(except_orgstruct_id)

    s_query = 
      from emp in Employee,
      join: em in EntityMember,
      on: em.member_id == emp.entity_id,
      where: em.entity_id == ^except_orgstruct.entity_id,
      select: emp.id

    query = 
      if orgstruct.type == :corporate_group or 
        orgstruct.type == :company do
        from emp in Employee,
        where: emp.orgstruct_id == ^orgstruct_id
        and emp.id not in subquery(s_query),
        select: emp
      else
        from emp in Employee,
        join: em in EntityMember,
        on: em.member_id == emp.entity_id,
        where: em.entity_id == ^orgstruct.entity_id
        and emp.id not in subquery(s_query),
        select: emp
      end

    if params["page"], do: query |> Repo.paginate(params),
    else: Repo.all(query)
  end

  def list_employee_members(%{"orgstruct_id" => orgstruct_id, "except_ids" => except_ids} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)

    query = from emp in Employee,
      join: em in EntityMember,
      on: em.member_id == emp.entity_id,
      where: em.entity_id == ^orgstruct.entity_id
      and emp.id not in ^except_ids,
    # select: {emp, em.id}
    select: emp

    if params["page"], do: query |> Repo.paginate(params),
    else: Repo.all(query)
  end

  def list_employee_members(%{"orgstruct_id" => orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)

    query = from emp in Employee,
      join: em in EntityMember,
      on: em.member_id == emp.entity_id,
      where: em.entity_id == ^orgstruct.entity_id,
    # select: {emp, em.id}
    select: emp

    if params["page"], do: query |> Repo.paginate(params),
    else: Repo.all(query)
  end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  def get_employee_entity_id!(id) do  
    employee = get_employee!(id) 
    employee.entity_id
  end

  def get_employee_by_entity_id!(entity_id) do  
    query = from emp in Employee, where: emp.entity_id == ^entity_id, select: emp
    Repo.all(query)
  end

  def get_employees_by_user_id!(user_id) do  
    query = from emp in Employee, where: emp.user_id == ^user_id, select: emp
    Repo.all(query)
  end

  def get_employee_by_user_orgstruct_ids!(user_id, orgstruct_id) do  
    query = from emp in Employee,
      where: emp.user_id == ^user_id
      and emp.orgstruct_id == ^orgstruct_id,
      select: emp
    Repo.all(query)
  end


  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :employee}),
           {:ok, employee} <- create_employee(%Employee{entity: entity}, attrs)
      do
        {:ok, employee}
      else 
        {:error, error} -> Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} ->
        broadcast(result, :employee_created)
        result
      error -> error
    end
  end

  # for create orgstruct init
  def create_employee(%Employee{} = employee_map, attrs) do
    employee_map |> Employee.changeset(attrs) |> Repo.insert()
  end


  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
    |> broadcast(:employee_updated)
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    #Repo.delete(employee)
    #|> broadcast(:employee_updated)

    Repo.transaction(fn ->
      entity_id = employee.entity_id
      employee_changeset = Repo.delete(employee)
      Entities.get_entity!(entity_id) |> Entities.delete_entity()
      employee_changeset
    end) |> case do
      {:ok,  result} -> 
        broadcast(result, :employee_deleted)
        result
    end

  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{data: %Employee{}}

  """
  def change_employee(%Employee{} = employee, attrs \\ %{}) do
    Employee.changeset(employee, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "employees")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, employee}, event) do
    # IO.puts "broadcast"
    Phoenix.PubSub.broadcast(Qukath.PubSub, "employees", {event, employee})
    {:ok, employee}
  end

end
