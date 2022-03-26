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

  @doc """
  Generate a action.
  """
  def action_fixture(attrs \\ %{}) do
    {:ok, action} =
      attrs
      |> Enum.into(%{
        verb: "some verb"
      })
      |> Qukath.Resources.create_action()

    action
  end
end
