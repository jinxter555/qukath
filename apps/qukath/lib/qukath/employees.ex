defmodule Qukath.Employees do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo
  alias Qukath.Entities

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
      with {:ok, employee_entity} <- Entities.create_entity(%{type: :employee}),
           {:ok, employee} <-  create_employee(employee_entity.id, attrs)  do
        {:ok, employee}
      else 
        err -> err
      end
    end) |> case do
      {:ok, result} ->  result
    end
  end

  def create_employee(entity_id, attrs) do
    attrs = Map.put(attrs, :entity_id, entity_id)
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
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
    Repo.delete(employee)
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

end
