defmodule Qukath.EmployeeRoles do
  @moduledoc """
  The EmployeeRole context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo
  alias Qukath.Entities
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

  def list_employee_roles(%{"employee_id" => employee_id}),  do:
    list_employee_roles(employee_id: employee_id)

  def list_employee_roles(employee_id: employee_id) do
    query = from er in EmployeeRole,
      where: er.employee_id == ^employee_id
    Repo.all(query) |> Repo.preload([:role])
  end

  def get_employee_role!(id), do: Repo.get!(EmployeeRole, id)


  ################################

  def create_employee_role(attrs \\ %{}) do
    IO.puts "begin create_employee_role"
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :employee_role}),
           {:ok, employee_role} <- 
             %EmployeeRole{entity: entity} |> EmployeeRole.changeset(attrs) |> Repo.insert()
      do
        {:ok, employee_role}
      else
        {:error, error} ->
          IO.puts "error create employee_role1"
          Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} -> 
        broadcast(result, :employee_role_created)
        result
      error -> 
          IO.puts "error create employee_role2"
        error
    end
  end

  def update_employee_role(%EmployeeRole{} = employee_role, attrs) do
    employee_role
    |> EmployeeRole.changeset(attrs)
    |> Repo.update()
    |> broadcast(:employee_role_updated)
  end

  def delete_employee_role(%EmployeeRole{} = employee_role) do
    Repo.transaction(fn ->
      entity_id = employee_role.entity_id
      employee_role_changeset = Repo.delete(employee_role)
      Entities.get_entity!(entity_id) |> Entities.delete_entity()
      employee_role_changeset
    end) |> case do
      {:ok, result} ->
        broadcast(result, :employee_role_deleted)
        result
    end
  end

  def change_employee_role(%EmployeeRole{} = employee_role, attrs \\ %{}) do
    EmployeeRole.changeset(employee_role, attrs)
  end

  ################################
            
  #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "employee_roles")
  end
        
  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, employee_role}, event) do
    Phoenix.PubSub.broadcast(Qukath.PubSub, "employee_roles", {event, employee_role})
    {:ok, employee_role}
  end
end
