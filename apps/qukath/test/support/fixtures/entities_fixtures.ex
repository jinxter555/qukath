defmodule Qukath.EntitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  """

  @doc """
  Generate a parent entity.
  """
  def entity_parent_fixture(attrs \\ %{}) do
    {:ok, entity} =
      attrs
      |> Enum.into(%{
        parent_id: nil,
        type: 100
      })
      |> Qukath.Entities.create_entity()

    entity
  end

  @doc """
  Generate a entity.
  """
  def entity_fixture(attrs \\ %{}) do
    parent_entity = entity_parent_fixture()

    {:ok, entity} =
      attrs
      |> Enum.into(%{
        parent_id: parent_entity.id,
        type: 100
      })
      |> Qukath.Entities.create_entity()

    entity
  end

  @doc """
  Generate a entity_member.
  """
  def entity_member_fixture(attrs \\ %{}) do
    entity = entity_fixture()
    member = entity_fixture()

    {:ok, entity_member} =
      attrs
      |> Enum.into(%{
        entity_id: entity.id,
        member_id: member.id
      })
      |> Qukath.Entities.create_entity_member()

    entity_member
  end
end
