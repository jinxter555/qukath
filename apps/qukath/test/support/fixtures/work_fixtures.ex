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
    orgstruct =  insert(:orgstruct)

    {:ok, todo} =
      attrs
      |> Enum.into(%{
        "orgstruct_id" => orgstruct.id,
        "description" => "make coffee in the morning",
        "name" => "morning wakeup",
        "state" => :notstarted,
        "type" => :task,
        # "sholder" => [entity: employee.entity, type: :owner],
        "sholder" => [],
      })
      |> Work.create_todo()
    todo # |> Map.drop([:entity, :owner_entity])
  end

  @doc """
  Generate a todo_state.
  """
  def todo_state_fixture(attrs \\ %{}) do
    {:ok, todo_state} =
      attrs
      |> Enum.into(%{
        state: :notstarted
      })
      |> Qukath.Work.create_todo_state()

    todo_state
  end

  @doc """
  Generate a todo_sholder.
  """
  def todo_sholder_fixture(attrs \\ %{}) do
    employee = insert(:employee)
    {:ok, todo_sholder} =
      attrs
      |> Enum.into(%{
        type: :owner,
        entity: employee.entity,
        approved: :yes
      })
      |> Qukath.Work.create_todo_sholder()

    todo_sholder
  end

  @doc """
  Generate a todo_info.
  """
  def todo_info_fixture(attrs \\ %{}) do
    {:ok, todo_info} =
      attrs
      |> Enum.into(%{
        dependency: "some dependency",
        description: "some description",
        name: "some name"
      })
      |> Qukath.Work.create_todo_info()

    todo_info
  end
end
