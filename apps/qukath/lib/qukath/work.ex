defmodule Qukath.Work do
  @moduledoc """
  The Work context.  Todo and Resources
  """

  import Ecto.Query, warn: false
  alias Qukath.Repo

  alias Qukath.Work.{Todo, TodoInfo, TodoState, TodoSholder}
  alias Qukath.Entities

  ##############
  @todo_info_preload_order todo_infos: from(ti in TodoInfo, order_by: [desc: ti.updated_at])
  @todo_state_preload_order todo_states: from(tst in TodoState, order_by: [desc: tst.updated_at])
  @todo_sholder_preload_order todo_sholders: from(tsh in TodoSholder, order_by: [desc: tsh.updated_at])
  ##############
  #
  def list_todos do
    Repo.all(Todo) 
  end

  def list_todos(%{"orgstruct_id" => orgstruct_id}), do:
      list_todos(orgstruct_id: orgstruct_id)

  def list_todos(orgstruct_id: orgstruct_id) do
    query = from t in Todo,
      where: t.orgstruct_id == ^orgstruct_id,
      select: t
    Repo.all(query) 
    |> Repo.preload([
      @todo_info_preload_order,
      @todo_state_preload_order,
      @todo_sholder_preload_order])
  end

  ##############
  def get_todo!(id) do
    Repo.get!(Todo, id) 
    |> Repo.preload([
      @todo_info_preload_order,
      @todo_state_preload_order,
      @todo_sholder_preload_order,
      :orgstruct]) 
    |> merge(:todo_infos)
    |> merge(:todo_states)
  end

  def get_todo_by_entity_id(entity_id) do
    query = from todo in Todo, where: todo.entity_id == ^entity_id, select: todo
    Repo.all(query) ++ [nil] |> hd
  end

  ## 
  ## merge todo nested child schemas into todo
  ##
  def merge(todo, child) when is_atom(child) do
    merge(todo, Map.get(todo, child))
  end

  def merge(todo, []), do: todo
  def merge(todo, [child | _l]), do: merge(todo, child)

  def merge(todo, child) do
    Map.merge(todo, child , fn k, v1, v2 ->
      case k do
        kk when kk in [
          :__meta__, :__struct__, :id, :type,
          :orgstruct_id, :updated_at , :inserted_at, :entity_id]
          -> v1
        _ -> v2
      end
    end)
  end

  ##############
  def create_todo(attrs \\ %{}) do
    Repo.transaction(fn ->
      with {:ok, entity} <- Entities.create_entity(%{type: :todo}),
           {:ok, todo} <- %Todo{entity: entity} |> Todo.changeset(attrs) |> Repo.insert(),
           {:ok, _todo_info} <- create_todo_info(todo, attrs),
           {:ok, _todo_state} <- create_todo_state(todo, attrs),
           {:ok, _todo_sholder} <- create_todo_sholder(todo, attrs["sholder"] )
      do
        {:ok, todo}
      else
        {:error, error} -> Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} -> 
        broadcast(result, :todo_created)
        result
      error -> error
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
    Repo.transaction(fn ->
      with {:ok, todo} <- Todo.changeset(todo, attrs) |> Repo.update(),
           {:ok, todo_info} <- todo.todo_infos |> hd |>  update_todo_info(attrs)
      do
        {:ok, {todo, todo_info}}
      else
        {:error, error} -> Repo.rollback(error)
      end
    end) |> case do
      {:ok, result} ->
        broadcast(result, :todo_updated)
        result
      error -> error
    end
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
      {:ok,  result} -> 
        broadcast(result, :todo_deleted)
        result
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

  ###########
  alias Qukath.Work.TodoState

  def list_todo_states do
    Repo.all(TodoState)
  end

  def get_todo_state!(id), do: Repo.get!(TodoState, id)

  def create_todo_state(todo, attrs \\ %{}) do
    %TodoState{todo_id: todo.id}
    |> TodoState.changeset(attrs)
    |> Repo.insert()
  end

  def update_todo_state(%TodoState{} = todo_state, attrs) do
    todo_state
    |> TodoState.changeset(attrs)
    |> Repo.update()
  end

  def delete_todo_state(%TodoState{} = todo_state) do
    Repo.delete(todo_state)
  end

  def change_todo_state(%TodoState{} = todo_state, attrs \\ %{}) do
    TodoState.changeset(todo_state, attrs)
  end
  #####################


  alias Qukath.Work.TodoSholder

  def list_todo_sholders do
    Repo.all(TodoSholder)
  end

  def get_todo_sholder!(id), do: Repo.get!(TodoSholder, id)

  def create_todo_sholder(todo), do: create_todo_sholder(todo, %{})

  def create_todo_sholder(todo, attrs ) when is_list(attrs) do
    result = Enum.map(attrs, fn x -> 
      create_todo_sholder(todo, x)
    end) 
    List.keyfind(result, :error, 0) || {:ok, result} # no errors return ok and list
  end

  def create_todo_sholder(todo, attrs) when is_map(attrs) do
    IO.puts "create_todo_sholder in  map"
    %TodoSholder{todo_id: todo.id}
    |> TodoSholder.changeset(attrs)
    |> Repo.insert()
  end

  def create_todo_sholder(todo, attrs)  do
    IO.puts "create_todo_sholder"
    IO.puts "no match"
    IO.puts "----"
    IO.inspect attrs
    IO.inspect todo
    IO.puts "----"
  end


  def update_todo_sholder(%TodoSholder{} = todo_sholder, attrs) do
    todo_sholder
    |> TodoSholder.changeset(attrs)
    |> Repo.update()
  end

  def delete_todo_sholder(%TodoSholder{} = todo_sholder) do
    Repo.delete(todo_sholder)
  end

  def change_todo_sholder(%TodoSholder{} = todo_sholder, attrs \\ %{}) do
    TodoSholder.changeset(todo_sholder, attrs)
  end

  #####################
  alias Qukath.Work.TodoInfo

  def list_todo_infos do
    Repo.all(TodoInfo)
  end

  def get_todo_info!(id), do: Repo.get!(TodoInfo, id)

  def create_todo_info(todo, attrs \\ %{}) do
    %TodoInfo{todo_id: todo.id}
    |> TodoInfo.changeset(attrs)
    |> Repo.insert()
  end

  def update_todo_info(%TodoInfo{} = todo_info, attrs) do
    todo_info
    |> TodoInfo.changeset(attrs)
    |> Repo.update()
  end
  def delete_todo_info(%TodoInfo{} = todo_info) do
    Repo.delete(todo_info)
  end
  def change_todo_info(%TodoInfo{} = todo_info, attrs \\ %{}) do
    TodoInfo.changeset(todo_info, attrs)
  end

  #########################
  def subscribe do
    Phoenix.PubSub.subscribe(Qukath.PubSub, "todos")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, todo}, event) do
    # IO.puts "broadcast"
    Phoenix.PubSub.broadcast(Qukath.PubSub, "todos", {event, todo})
    {:ok, todo}
  end

end
