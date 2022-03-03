defmodule Qukath.RoleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.Role` context.
  """

  @doc """
  Generate a role_info.
  """
  def role_info_fixture(attrs \\ %{}) do
    {:ok, role_info} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Qukath.Role.create_role_info()

    role_info
  end
end
