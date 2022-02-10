defmodule Qukath.Work do
  @moduledoc """
  The Work context.  Todo and Resources
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Work.Todo
  alias Qukath.Entities

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos do
    Repo.all(Todo) # |> Repo.preload([:assignto_entity])
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  @doc """
  Creates a todo.

  ## Examples
  # create_todo(%{owner_entity_id: owner_entity_id, description: String.t(), type: [:task|:list|:project], ...}) 

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :todo}) do
        %Todo{entity: entity}
        |> Todo.changeset(attrs)
        |> Repo.insert()
      end
    end) |> case do
      {:ok, result} -> result
    end
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.transaction(fn ->
      entity_id = todo.entity_id
      todo_changeset = Repo.delete(todo)
      Entities.get_entity!(entity_id) |> Entities.delete_entity()
      todo_changeset
    end) |> case do
      {:ok,  result} -> result
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{data: %Todo{}}

  """
  def change_todo(%Todo{} = todo, attrs \\ %{}) do
    Todo.changeset(todo, attrs)
  end

end
