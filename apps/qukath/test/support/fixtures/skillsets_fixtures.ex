defmodule Qukath.SkillsetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Qukath.Skillsets` context.
  """

  @doc """
  Generate a skillset.
  """
  def skillset_fixture(attrs \\ %{}) do
    {:ok, skillset} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Qukath.Skillsets.create_skillset()

    skillset
  end
end
