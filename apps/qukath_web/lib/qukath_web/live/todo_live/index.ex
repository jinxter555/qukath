defmodule QukathWeb.TodoLive.Index do
  use Surface.LiveView

  alias Qukath.Work
  alias Qukath.Orgstructs
  alias QukathWeb.TodoLive.TodoFormBulma
  alias Surface.Components.{Link,LiveRedirect}
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.ExtraHelper, only: [hide_deleted: 2]

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Work.subscribe()
    {:ok,
      socket
      |> assign(:orgstruct, nil)
      |> assign(:todos, []),
      temporary_assigns: [todos: []]
    }
  end
  
  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)
    }
  end


  defp apply_action(socket, :orgstruct, params), do:
    apply_action(socket, :index, params) 

  defp apply_action(socket, :index, %{"orgstruct_id" => orgstruct_id} = params) do
    orgstruct = Orgstructs.get_orgstruct!(orgstruct_id)
    socket
    |> assign(:todos, Work.list_todos(params))
    |> assign(:orgstruct, orgstruct)
    |> assign(:page_title, "listing todos for #{orgstruct.name}")
  end

  defp apply_action(socket, :index, _params) do
  socket
    |> assign(:todos, Work.list_todos())
    |> assign(:page_title, "listing todos")
  end

  @impl true
  def handle_event("todo_form", params, socket) do
    IO.puts "todo_form"
    IO.inspect params
    TodoFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:todo_created, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  @impl true
  def handle_info({:todo_updated, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  @impl true
  def handle_info({:todo_deleted, todo}, socket) do
    {:noreply, update(socket, :todos, fn todos ->
      [todo | todos]
    end)}
  end

  def todo_form_cid() do
    "tfb01"
  end

  def merge_info(todo) do
    Work.merge(todo, :todo_infos)
  end


end

