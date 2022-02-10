defmodule Qukath.WorkTest do
  use Qukath.DataCase

  alias Qukath.Work
  alias Qukath.Work.Todo

  alias Qukath.Repo


  import Qukath.Factory

  describe "todos" do

    import Qukath.WorkFixtures

    @invalid_attrs %{description: nil, state: nil, type: nil}

    #@tag :skip
    test "list_todos/1 returns all todos" do
      todo = todo_fixture()  |> forget(:entity) |> forget(:owner_entity)
      assert Work.list_todos() == [todo]
    end

    #@tag :skip
    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
             |> forget(:entity)
             |> forget(:owner_entity)

      assert Work.get_todo!(todo.id) == todo
    end

    #@tag :skip
    test "create_todo/1 with valid data creates a todo" do
      employee = build(:employee)

      valid_attrs = %{description: "some description",
        type: :task, state: 42,
        owner_entity_id: employee.entity.id}

      assert {:ok, %Todo{} = todo} = Work.create_todo(valid_attrs)
      assert todo.description == "some description"
      assert todo.type == :task

    end

    # @tag :skip
    test "create_todo/1 with invalid data returns error changeset" do
      invalid_attrs = %{description: nil, owner_entity_id: nil, type: nil, state: nil}
      assert {:error, %Ecto.Changeset{}} = Work.create_todo(invalid_attrs)
    end

    # @tag :skip
    test "update_todo/2 with parent/child entity" do
      employee1 = build(:employee)
      employee2 = build(:employee)

      todo = todo_fixture() |> Repo.preload([:assignto_entity])

      update_attrs = %{
        description: "some updated description",
        state: 43,
        type: :task
      }

      {:ok, todo_updated1} = 
        todo
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:assignto_entity, employee1.entity)
        |> Todo.changeset(update_attrs)
        |> Repo.update()

      {:ok, todo_updated_nil} = 
        todo_updated1
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:assignto_entity, nil)
        |> Todo.changeset(update_attrs)
        |> Repo.update()

      todo_selected1 = 
        Work.get_todo!(todo_updated_nil.id) 
        |> Repo.preload([:entity, :owner_entity, :assignto_entity])


      {:ok, todo_updated2} = 
        todo_selected1
        #todo_updated_nil
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:assignto_entity, employee2.entity)
        |> Todo.changeset(update_attrs)
        |> Repo.update()

      todo_selected2 = 
        Work.get_todo!(todo_updated2.id) 
        |> Repo.preload([:entity, :owner_entity, :assignto_entity])

      refute todo_updated1.assignto_entity == todo_selected2.assignto_entity
    end


    # @tag :skip
    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      employee = insert(:employee)
      update_attrs = %{
        assignto_entity_id: employee.entity.id,
        description: "some updated description", state: 43, type: :task,
      }

      assert {:ok, %Todo{} = todo} = Work.update_todo(todo, update_attrs)
      assert todo.description == "some updated description"
      assert todo.state == 43
      assert todo.type == :task
    end

    # @tag :skip
    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
             |> forget(:entity)
             |> forget(:owner_entity)
      assert {:error, %Ecto.Changeset{}} = Work.update_todo(todo, @invalid_attrs)
      assert todo == Work.get_todo!(todo.id) 
    end

    # @tag :skip
    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Work.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Work.get_todo!(todo.id) end
    end

    # @tag :skip
    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Work.change_todo(todo)
    end
  end


  def forget(struct, field, cardinality \\ :one) do
    %{struct | 
      field => %Ecto.Association.NotLoaded{
        __field__: field,
        __owner__: struct.__struct__,
        __cardinality__: cardinality
      }
    }
  end



end
