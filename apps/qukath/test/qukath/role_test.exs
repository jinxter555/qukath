defmodule Qukath.RoleTest do
  use Qukath.DataCase

  alias Qukath.Role

  describe "role_infos" do
    alias Qukath.Role.RoleInfo

    import Qukath.RoleFixtures

    @invalid_attrs %{name: nil}

    test "list_role_infos/0 returns all role_infos" do
      role_info = role_info_fixture()
      assert Role.list_role_infos() == [role_info]
    end

    test "get_role_info!/1 returns the role_info with given id" do
      role_info = role_info_fixture()
      assert Role.get_role_info!(role_info.id) == role_info
    end

    test "create_role_info/1 with valid data creates a role_info" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %RoleInfo{} = role_info} = Role.create_role_info(valid_attrs)
      assert role_info.name == "some name"
    end

    test "create_role_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Role.create_role_info(@invalid_attrs)
    end

    test "update_role_info/2 with valid data updates the role_info" do
      role_info = role_info_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %RoleInfo{} = role_info} = Role.update_role_info(role_info, update_attrs)
      assert role_info.name == "some updated name"
    end

    test "update_role_info/2 with invalid data returns error changeset" do
      role_info = role_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Role.update_role_info(role_info, @invalid_attrs)
      assert role_info == Role.get_role_info!(role_info.id)
    end

    test "delete_role_info/1 deletes the role_info" do
      role_info = role_info_fixture()
      assert {:ok, %RoleInfo{}} = Role.delete_role_info(role_info)
      assert_raise Ecto.NoResultsError, fn -> Role.get_role_info!(role_info.id) end
    end

    test "change_role_info/1 returns a role_info changeset" do
      role_info = role_info_fixture()
      assert %Ecto.Changeset{} = Role.change_role_info(role_info)
    end
  end
end
