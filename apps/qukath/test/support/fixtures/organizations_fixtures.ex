defmodule Qukath.OrganizationsFixtures do
  import Qukath.Factory

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.Organizations` context.
  """

  @doc """
  Generate a employee.
  """
  def employee_fixture(_attrs \\ %{}) do
     insert(:employee)
  end

  @doc """
  Generate a orgstruct.
  """
  def orgstruct_fixture(_attrs \\ %{}) do
    insert(:orgstruct)
  end
end
