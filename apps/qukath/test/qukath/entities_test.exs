defmodule Qukath.EntitiesTest do
  use Qukath.DataCase

  alias Qukath.Entities

  describe "entities" do
    alias Qukath.Entities.Entity

    import Qukath.EntitiesFixtures

    @invalid_attrs %{parent_id: nil, type: nil}
 
    @tag :skip
    test "list_entities/0 return parent nil entity" do
      entity = entity_parent_fixture()
      assert Entities.list_entities() == [entity]
    end

    @tag :skip
    test "get_entity!/1 returns the entity with given id" do
      entity = entity_fixture()
      assert Entities.get_entity!(entity.id) == entity
    end

    @tag :skip
    test "create_entity/1 with valid data creates a entity" do
      parent = entity_parent_fixture()
      valid_attrs = %{parent_id: parent.id, type: :employee}

      assert {:ok, %Entity{} = entity} = Entities.create_entity(valid_attrs)
      assert entity.parent_id == parent.id
      assert entity.type == :employee
    end

    @tag :skip
    test "create_entity/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entities.create_entity(@invalid_attrs)
    end

    @tag :skip
    test "update_entity/2 with valid data updates the entity" do
      entity = entity_fixture()
      update_attrs = %{parent_id: nil, type: :employee}

      assert {:ok, %Entity{} = entity} = Entities.update_entity(entity, update_attrs)
      assert entity.parent_id == nil
      assert entity.type == :employee
    end

    @tag :skip
    test "update_entity/2 with invalid data returns error changeset" do
      entity = entity_fixture()
      assert {:error, %Ecto.Changeset{}} = Entities.update_entity(entity, @invalid_attrs)
      assert entity == Entities.get_entity!(entity.id)
    end

    @tag :skip
    test "delete_entity/1 deletes the entity" do
      entity = entity_fixture()
      assert {:ok, %Entity{}} = Entities.delete_entity(entity)
      assert_raise Ecto.NoResultsError, fn -> Entities.get_entity!(entity.id) end
    end

    @tag :skip
    test "change_entity/1 returns a entity changeset" do
      entity = entity_fixture()
      assert %Ecto.Changeset{} = Entities.change_entity(entity)
    end
  end

  describe "entity_members" do
    alias Qukath.Entities.EntityMember

    import Qukath.EntitiesFixtures

    @invalid_attrs %{entity_id: nil, member_id: nil}

    # @tag :skip
    test "list_entity_members/1 returns all entity_members" do
      entity_member = entity_member_fixture()
      assert Entities.list_entity_members() == [entity_member]
    end

    # @tag :skip
    test "get_entity_member!/1 returns the entity_member with given id" do
      entity_member = entity_member_fixture()
      assert Entities.get_entity_member!(entity_member.id) == entity_member
    end

    # @tag :skip
    test "create_entity_member/1 with valid data creates a entity_member" do
      entity1 = entity_fixture() 
      entity2 = entity_fixture() 
      valid_attrs = %{entity_id: entity1.id, member_id: entity2.id}

      assert {:ok, %EntityMember{} = entity_member} = Entities.create_entity_member(valid_attrs)
      assert entity_member.entity_id == entity1.id
      assert entity_member.member_id == entity2.id
    end

    # @tag :skip
    test "create_entity_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Entities.create_entity_member(@invalid_attrs)
    end

    #@tag :skip
    test "update_entity_member/2 with valid data updates the entity_member" do
      entity_member = entity_member_fixture()
      entity1 = entity_fixture() 
      entity2 = entity_fixture() 
      update_attrs = %{entity_id: entity1.id, member_id: entity2.id}

      assert {:ok, %EntityMember{} = entity_member} = Entities.update_entity_member(entity_member, update_attrs)
      assert entity_member.entity_id == entity1.id
      assert entity_member.member_id == entity2.id
    end

    # @tag :skip
    test "update_entity_member/2 with invalid data returns error changeset" do
      entity_member = entity_member_fixture()
      assert {:error, %Ecto.Changeset{}} = Entities.update_entity_member(entity_member, @invalid_attrs)
      assert entity_member == Entities.get_entity_member!(entity_member.id)
    end

    # @tag :skip
    test "delete_entity_member/1 deletes the entity_member" do
      entity_member = entity_member_fixture()
      assert {:ok, %EntityMember{}} = Entities.delete_entity_member(entity_member)
      assert_raise Ecto.NoResultsError, fn -> Entities.get_entity_member!(entity_member.id) end
    end

    # @tag :skip
    test "change_entity_member/1 returns a entity_member changeset" do
      entity_member = entity_member_fixture()
      assert %Ecto.Changeset{} = Entities.change_entity_member(entity_member)
    end
  end
end
