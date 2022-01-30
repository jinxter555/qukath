defmodule Qukath.Orgstructs do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Organizations.Orgstruct
  alias Qukath.Employees
  alias Qukath.Entities
  alias Qukath.Accounts

  @doc """
  Returns the list of orgstructs.

  ## Examples

      iex> list_orgstructs()
      [%Orgstruct{}, ...]

  """
  def list_orgstructs do
    Repo.all(Orgstruct)
  end

  @doc """
  Gets a single orgstruct.

  Raises `Ecto.NoResultsError` if the Orgstruct does not exist.

  ## Examples

      iex> get_orgstruct!(123)
      %Orgstruct{}

      iex> get_orgstruct!(456)
      ** (Ecto.NoResultsError)

  """
  def get_orgstruct!(id), do: Repo.get!(Orgstruct, id)

  @doc """
  Creates a orgstruct.

  ## Examples

      iex> create_orgstruct(%{field: value})
      {:ok, %Orgstruct{}}

      iex> create_orgstruct(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_orgstruct(attrs \\ %{}) do
    Repo.transaction(fn ->
      orgstruct_entity = Entities.create_entity(%{type: :org})
      create_orgstruct(orgstruct_entity.id, attrs)
    end)
  end

  def create_orgstruct(entity_id, attrs) do
    attrs = Map.put(attrs, :entity_id, entity_id)
    %Orgstruct{}
    |> Orgstruct.changeset(attrs)
    |> Repo.insert()
  end

  def create_orgstruct_init(user_id, attrs \\ %{}) do
    user = Accounts.get_user!(user_id)
    Repo.transaction(fn ->
      leader_entity = Entities.create_entity(%{type: :employee})
      orgstruct_entity = Entities.create_entity(%{type: :org})

      attrs = Map.put(attrs, :leader_entity_id, leader_entity.id)
      orgstruct = create_orgstruct(orgstruct_entity.id, attrs)
      Employees.create_employee(leader_entity.id, %{user_id: user.id, orgstruct_id: orgstruct.id})
      orgstruct
    end)
  end

  @doc """
  Updates a orgstruct.

  ## Examples

      iex> update_orgstruct(orgstruct, %{field: new_value})
      {:ok, %Orgstruct{}}

      iex> update_orgstruct(orgstruct, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_orgstruct(%Orgstruct{} = orgstruct, attrs) do
    orgstruct
    |> Orgstruct.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a orgstruct.

  ## Examples

      iex> delete_orgstruct(orgstruct)
      {:ok, %Orgstruct{}}

      iex> delete_orgstruct(orgstruct)
      {:error, %Ecto.Changeset{}}

  """
  def delete_orgstruct(%Orgstruct{} = orgstruct) do
    Repo.delete(orgstruct)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking orgstruct changes.

  ## Examples

      iex> change_orgstruct(orgstruct)
      %Ecto.Changeset{data: %Orgstruct{}}

  """
  def change_orgstruct(%Orgstruct{} = orgstruct, attrs \\ %{}) do
    Orgstruct.changeset(orgstruct, attrs)
  end
end
