defmodule Qukath.EmployeexRoleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.EmployeexRole` context.
  """

  @doc """
  Generate a employee_role.
  """
  def employee_role_fixture(attrs \\ %{}) do
    {:ok, employee_role} =
      attrs
      |> Enum.into(%{

      })
      |> Qukath.EmployeexRole.create_employee_role()

    employee_role
  end
end
