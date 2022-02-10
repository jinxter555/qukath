defmodule Qukath.WorkFixtures do
  import Qukath.Factory

  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qujump.Work` context.
  """

  alias Qukath.Work

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    employee = insert(:employee)
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        owner_entity_id: employee.entity.id,
        description: "make coffee in the morning",
        state: 42,
        type: :task
      })
      |> Work.create_todo()
    todo # |> Map.drop([:entity, :owner_entity])
  end
end
