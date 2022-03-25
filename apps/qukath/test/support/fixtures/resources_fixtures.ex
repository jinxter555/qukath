defmodule Qukath.ResourcesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.Resources` context.
  """

  @doc """
  Generate a resource.
  """
  def resource_fixture(attrs \\ %{}) do
    {:ok, resource} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Qukath.Resources.create_resource()

    resource
  end
end
