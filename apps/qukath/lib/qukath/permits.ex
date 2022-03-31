defmodule Qukath.Permits do
  @moduledoc """
  The Resources context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Resources.Permit

  @doc """
  Returns the list of permits.

  ## Examples

      iex> list_permits()
      [%Permit{}, ...]

  """
  def list_permits do
    Repo.all(Permit)
  end

  def list_permits(%{"resource_id" => resource_id}), do:
      list_permits(resource_id: resource_id)

  def list_permits(resource_id: resource_id) do
    query = from p in Permit,
      where: p.resource_id == ^resource_id,
      select: p
    Repo.all(query) 
  end

  @doc """
  Gets a single permits.

  Raises `Ecto.NoResultsError` if the Permit does not exist.

  ## Examples

      iex> get_permit!(123)
      %Permit{}

      iex> get_permit!(456)
      ** (Ecto.NoResultsError)

  """
  def get_permit!(id), do: Repo.get!(Permit, id)

  @doc """
  Creates a permits!.

  ## Examples

      iex> create_permits(%{field: value})
      {:ok, %Permit{}}

      iex> create_permits(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_permit(attrs \\ %{}) do
    %Permit{}
    |> Permit.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:permit_created)
  end

  @doc """
  Updates a permit.

  ## Examples

      iex> update_permit(permit, %{field: new_value})
      {:ok, %Permit{}}

      iex> update_permit(permit, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_permit(%Permit{} = permit, attrs) do
    permit
    |> Permit.changeset(attrs)
    |> Repo.update()
    |> broadcast(:permit_updated)
  end

  @doc """
  Deletes a permit.

  ## Examples

      iex> delete_permit(permit)
      {:ok, %Permit{}}

      iex> delete_permit(permit)
      {:error, %Ecto.Changeset{}}

  """
  def delete_permit(%Permit{} = permit) do
    Repo.delete(permit)
    |> broadcast(:permit_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking permit changes.

  ## Examples

      iex> change_permit(permit)
      %Ecto.Changeset{data: %Permit{}}

  """
  def change_permit(%Permit{} = permit, attrs \\ %{}) do
    Permit.changeset(permit, attrs)
  end


  
   #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "permits")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, permit}, event) do
    Phoenix.PubSub.broadcast(Qukath.PubSub, "permits", {event, permit})
    {:ok, permit}
  end

end
