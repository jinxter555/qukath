defmodule Qukath.Skillsets do
  @moduledoc """
  The Skillsets context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Roles.Skillset

  @doc """
  Returns the list of skillsets.

  ## Examples

      iex> list_skillsets()
      [%Skillset{}, ...]

  """
  def list_skillsets do
    Repo.all(Skillset)
  end

  def list_skillsets(%{"role_id" => role_id}), do:
      list_skillsets(role_id: role_id)

  def list_skillsets(role_id: role_id) do
    query = from s in Skillset,
      where: s.role_id == ^role_id,
      select: s
    Repo.all(query) 
  end

  @doc """
  Gets a single skillset.

  Raises `Ecto.NoResultsError` if the Skillset does not exist.

  ## Examples

      iex> get_skillset!(123)
      %Skillset{}

      iex> get_skillset!(456)
      ** (Ecto.NoResultsError)

  """
  def get_skillset!(id), do: Repo.get!(Skillset, id)

  @doc """
  Creates a skillset.

  ## Examples

      iex> create_skillset(%{field: value})
      {:ok, %Skillset{}}

      iex> create_skillset(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_skillset(attrs \\ %{}) do
    %Skillset{}
    |> Skillset.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:skillset_created)

  end

  @doc """
  Updates a skillset.

  ## Examples

      iex> update_skillset(skillset, %{field: new_value})
      {:ok, %Skillset{}}

      iex> update_skillset(skillset, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_skillset(%Skillset{} = skillset, attrs) do
    skillset
    |> Skillset.changeset(attrs)
    |> Repo.update()
    |> broadcast(:skillset_updated)
  end

  @doc """
  Deletes a skillset.

  ## Examples

      iex> delete_skillset(skillset)
      {:ok, %Skillset{}}

      iex> delete_skillset(skillset)
      {:error, %Ecto.Changeset{}}

  """
  def delete_skillset(%Skillset{} = skillset) do
    Repo.delete(skillset)
    |> broadcast(:skillset_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking skillset changes.

  ## Examples

      iex> change_skillset(skillset)
      %Ecto.Changeset{data: %Skillset{}}

  """
  def change_skillset(%Skillset{} = skillset, attrs \\ %{}) do
    Skillset.changeset(skillset, attrs)
  end


   #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "skillsets")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, skillset}, event) do
    Phoenix.PubSub.broadcast(Qukath.PubSub, "skillsets", {event, skillset})
    {:ok, skillset}
  end


end
