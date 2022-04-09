defmodule Qukath.SkillsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.Skills` context.
  """

  @doc """
  Generate a skill.
  """
  def skill_fixture(attrs \\ %{}) do
    {:ok, skill} =
      attrs
      |> Enum.into(%{

      })
      |> Qukath.Skills.create_skill()

    skill
  end
end
