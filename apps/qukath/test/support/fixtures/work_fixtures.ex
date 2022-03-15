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
    orgstruct =  insert(:orgstruct)
    employee_role = insert(:employee_role)

    {:ok, todo} =
      attrs
      |> Enum.into(%{
        "orgstruct_id" => orgstruct.id,
        "description" => "make coffee in the morning",
        "name" => "morning wakeup",
        "state" => :notstarted,
        "type" => :task,
        # "sholder" => [entity: employee.entity, type: :owner],
        "sholder" => [%{type: :owner, entity: employee_role.entity, approved: :yes}],
      })
      |> Work.create_todo()
    todo # |> Map.drop([:entity, :owner_entity])
  end

  @doc """
  Generate a todo_state.
  """
  def todo_state_fixture(attrs \\ %{}) do
    todo = insert(:todo)
    {:ok, todo_state} =
      Qukath.Work.create_todo_state(todo, 
        attrs |> Enum.into(%{ state: :notstarted }))
    todo_state
  end

  @doc """
  Generate a todo_sholder.
  """
  def todo_sholder_fixture(attrs \\ %{}) do
    todo = insert(:todo)
    employee_role = insert(:employee_role)
    {:ok, todo_sholder} =
      Qukath.Work.create_todo_sholder(todo, Enum.into(attrs, %{ type: :owner, entity: employee_role.entity, approved: :yes
      }))

    todo_sholder
  end

  @doc """
  Generate a todo_info.
  """
  def todo_info_fixture(attrs \\ %{}) do
    todo = insert(:todo)
    {:ok, todo_info} =
      Qukath.Work.create_todo_info(todo, 
        Enum.into(attrs, %{
        dependency: "some dependency",
        description: "some description",
        name: "some name"
      }))

    todo_info
  end
end
