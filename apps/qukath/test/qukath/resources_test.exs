defmodule Qukath.ResourcesTest do
  use Qukath.DataCase

  alias Qukath.Resources

  describe "resources" do
    alias Qukath.Resources.Resource

    import Qukath.ResourcesFixtures

    @invalid_attrs %{name: nil}

    test "list_resources/0 returns all resources" do
      resource = resource_fixture()
      assert Resources.list_resources() == [resource]
    end

    test "get_resource!/1 returns the resource with given id" do
      resource = resource_fixture()
      assert Resources.get_resource!(resource.id) == resource
    end

    test "create_resource/1 with valid data creates a resource" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Resource{} = resource} = Resources.create_resource(valid_attrs)
      assert resource.name == "some name"
    end

    test "create_resource/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_resource(@invalid_attrs)
    end

    test "update_resource/2 with valid data updates the resource" do
      resource = resource_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Resource{} = resource} = Resources.update_resource(resource, update_attrs)
      assert resource.name == "some updated name"
    end

    test "update_resource/2 with invalid data returns error changeset" do
      resource = resource_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_resource(resource, @invalid_attrs)
      assert resource == Resources.get_resource!(resource.id)
    end

    test "delete_resource/1 deletes the resource" do
      resource = resource_fixture()
      assert {:ok, %Resource{}} = Resources.delete_resource(resource)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_resource!(resource.id) end
    end

    test "change_resource/1 returns a resource changeset" do
      resource = resource_fixture()
      assert %Ecto.Changeset{} = Resources.change_resource(resource)
    end
  end

  describe "actions" do
    alias Qukath.Resources.Action

    import Qukath.ResourcesFixtures

    @invalid_attrs %{verb: nil}

    test "list_actions/0 returns all actions" do
      action = action_fixture()
      assert Resources.list_actions() == [action]
    end

    test "get_action!/1 returns the action with given id" do
      action = action_fixture()
      assert Resources.get_action!(action.id) == action
    end

    test "create_action/1 with valid data creates a action" do
      valid_attrs = %{verb: "some verb"}

      assert {:ok, %Action{} = action} = Resources.create_action(valid_attrs)
      assert action.verb == "some verb"
    end

    test "create_action/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Resources.create_action(@invalid_attrs)
    end

    test "update_action/2 with valid data updates the action" do
      action = action_fixture()
      update_attrs = %{verb: "some updated verb"}

      assert {:ok, %Action{} = action} = Resources.update_action(action, update_attrs)
      assert action.verb == "some updated verb"
    end

    test "update_action/2 with invalid data returns error changeset" do
      action = action_fixture()
      assert {:error, %Ecto.Changeset{}} = Resources.update_action(action, @invalid_attrs)
      assert action == Resources.get_action!(action.id)
    end

    test "delete_action/1 deletes the action" do
      action = action_fixture()
      assert {:ok, %Action{}} = Resources.delete_action(action)
      assert_raise Ecto.NoResultsError, fn -> Resources.get_action!(action.id) end
    end

    test "change_action/1 returns a action changeset" do
      action = action_fixture()
      assert %Ecto.Changeset{} = Resources.change_action(action)
    end
  end
end
