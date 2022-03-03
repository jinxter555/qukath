defmodule Qukath.EmployeeRole do
  @moduledoc """
  The EmployeeRole context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Roles.EmployeeRole

  @doc """
  Returns the list of employee_roles.

  ## Examples

      iex> list_employee_roles()
      [%EmployeeRole{}, ...]

  """
  def list_employee_roles do
    Repo.all(EmployeeRole)
  end

  @doc """
  Gets a single employee_role.

  Raises `Ecto.NoResultsError` if the Employee role does not exist.

  ## Examples

      iex> get_employee_role!(123)
      %EmployeeRole{}

      iex> get_employee_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee_role!(id), do: Repo.get!(EmployeeRole, id)

  @doc """
  Creates a employee_role.

  ## Examples

      iex> create_employee_role(%{field: value})
      {:ok, %EmployeeRole{}}

      iex> create_employee_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee_role(attrs \\ %{}) do
    %EmployeeRole{}
    |> EmployeeRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee_role.

  ## Examples

      iex> update_employee_role(employee_role, %{field: new_value})
      {:ok, %EmployeeRole{}}

      iex> update_employee_role(employee_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee_role(%EmployeeRole{} = employee_role, attrs) do
    employee_role
    |> EmployeeRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee_role.

  ## Examples

      iex> delete_employee_role(employee_role)
      {:ok, %EmployeeRole{}}

      iex> delete_employee_role(employee_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee_role(%EmployeeRole{} = employee_role) do
    Repo.delete(employee_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee_role changes.

  ## Examples

      iex> change_employee_role(employee_role)
      %Ecto.Changeset{data: %EmployeeRole{}}

  """
  def change_employee_role(%EmployeeRole{} = employee_role, attrs \\ %{}) do
    EmployeeRole.changeset(employee_role, attrs)
  end
end
