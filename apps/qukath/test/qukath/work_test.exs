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




  describe "todo_states" do
    alias Qukath.Work.TodoState

    import Qukath.WorkFixtures

    @invalid_attrs %{state: nil}

    test "list_todo_states/0 returns all todo_states" do
      todo_state = todo_state_fixture()
      assert Work.list_todo_states() == [todo_state]
    end

    test "get_todo_state!/1 returns the todo_state with given id" do
      todo_state = todo_state_fixture()
      assert Work.get_todo_state!(todo_state.id) == todo_state
    end

    test "create_todo_state/1 with valid data creates a todo_state" do
      valid_attrs = %{state: 42}

      assert {:ok, %TodoState{} = todo_state} = Work.create_todo_state(valid_attrs)
      assert todo_state.state == 42
    end

    test "create_todo_state/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_todo_state(@invalid_attrs)
    end

    test "update_todo_state/2 with valid data updates the todo_state" do
      todo_state = todo_state_fixture()
      update_attrs = %{state: 43}

      assert {:ok, %TodoState{} = todo_state} = Work.update_todo_state(todo_state, update_attrs)
      assert todo_state.state == 43
    end

    test "update_todo_state/2 with invalid data returns error changeset" do
      todo_state = todo_state_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_todo_state(todo_state, @invalid_attrs)
      assert todo_state == Work.get_todo_state!(todo_state.id)
    end

    test "delete_todo_state/1 deletes the todo_state" do
      todo_state = todo_state_fixture()
      assert {:ok, %TodoState{}} = Work.delete_todo_state(todo_state)
      assert_raise Ecto.NoResultsError, fn -> Work.get_todo_state!(todo_state.id) end
    end

    test "change_todo_state/1 returns a todo_state changeset" do
      todo_state = todo_state_fixture()
      assert %Ecto.Changeset{} = Work.change_todo_state(todo_state)
    end
  end

  describe "todo_sholders" do
    alias Qukath.Work.TodoSholder

    import Qukath.WorkFixtures

    @invalid_attrs %{}

    test "list_todo_sholders/0 returns all todo_sholders" do
      todo_sholder = todo_sholder_fixture()
      assert Work.list_todo_sholders() == [todo_sholder]
    end

    test "get_todo_sholder!/1 returns the todo_sholder with given id" do
      todo_sholder = todo_sholder_fixture()
      assert Work.get_todo_sholder!(todo_sholder.id) == todo_sholder
    end

    test "create_todo_sholder/1 with valid data creates a todo_sholder" do
      valid_attrs = %{}

      assert {:ok, %TodoSholder{} = todo_sholder} = Work.create_todo_sholder(valid_attrs)
    end

    test "create_todo_sholder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_todo_sholder(@invalid_attrs)
    end

    test "update_todo_sholder/2 with valid data updates the todo_sholder" do
      todo_sholder = todo_sholder_fixture()
      update_attrs = %{}

      assert {:ok, %TodoSholder{} = todo_sholder} = Work.update_todo_sholder(todo_sholder, update_attrs)
    end

    test "update_todo_sholder/2 with invalid data returns error changeset" do
      todo_sholder = todo_sholder_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_todo_sholder(todo_sholder, @invalid_attrs)
      assert todo_sholder == Work.get_todo_sholder!(todo_sholder.id)
    end

    test "delete_todo_sholder/1 deletes the todo_sholder" do
      todo_sholder = todo_sholder_fixture()
      assert {:ok, %TodoSholder{}} = Work.delete_todo_sholder(todo_sholder)
      assert_raise Ecto.NoResultsError, fn -> Work.get_todo_sholder!(todo_sholder.id) end
    end

    test "change_todo_sholder/1 returns a todo_sholder changeset" do
      todo_sholder = todo_sholder_fixture()
      assert %Ecto.Changeset{} = Work.change_todo_sholder(todo_sholder)
    end
  end

  describe "todo_infos" do
    alias Qukath.Work.TodoInfo

    import Qukath.WorkFixtures

    @invalid_attrs %{dependency: nil, description: nil, name: nil}

    test "list_todo_infos/0 returns all todo_infos" do
      todo_info = todo_info_fixture()
      assert Work.list_todo_infos() == [todo_info]
    end

    test "get_todo_info!/1 returns the todo_info with given id" do
      todo_info = todo_info_fixture()
      assert Work.get_todo_info!(todo_info.id) == todo_info
    end

    test "create_todo_info/1 with valid data creates a todo_info" do
      valid_attrs = %{dependency: "some dependency", description: "some description", name: "some name"}

      assert {:ok, %TodoInfo{} = todo_info} = Work.create_todo_info(valid_attrs)
      assert todo_info.dependency == "some dependency"
      assert todo_info.description == "some description"
      assert todo_info.name == "some name"
    end

    test "create_todo_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Work.create_todo_info(@invalid_attrs)
    end

    test "update_todo_info/2 with valid data updates the todo_info" do
      todo_info = todo_info_fixture()
      update_attrs = %{dependency: "some updated dependency", description: "some updated description", name: "some updated name"}

      assert {:ok, %TodoInfo{} = todo_info} = Work.update_todo_info(todo_info, update_attrs)
      assert todo_info.dependency == "some updated dependency"
      assert todo_info.description == "some updated description"
      assert todo_info.name == "some updated name"
    end

    test "update_todo_info/2 with invalid data returns error changeset" do
      todo_info = todo_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Work.update_todo_info(todo_info, @invalid_attrs)
      assert todo_info == Work.get_todo_info!(todo_info.id)
    end

    test "delete_todo_info/1 deletes the todo_info" do
      todo_info = todo_info_fixture()
      assert {:ok, %TodoInfo{}} = Work.delete_todo_info(todo_info)
      assert_raise Ecto.NoResultsError, fn -> Work.get_todo_info!(todo_info.id) end
    end

    test "change_todo_info/1 returns a todo_info changeset" do
      todo_info = todo_info_fixture()
      assert %Ecto.Changeset{} = Work.change_todo_info(todo_info)
    end
  end
end
