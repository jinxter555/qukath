defmodule QukathWeb.TodoLive.TodoIndexTodos do
  use Surface.Component

  import QukathWeb.TodoLive.TodoIndex, only: [todo_form_cid: 0]

  alias Surface.Components.Link


  prop todos, :list, required: true
  # prop todo_attach, :fun, required: true
  prop todo_attach, :fun, default: nil
  prop update_mode, :string, default: "append"
  prop update_id, :string, default: "todos"


  def render(assigns) do
    ~F"""
      <div id={@update_id<>"s"} phx-update={@update_mode}>
        {#for todo <- @todos }
        <div id={@update_id <> "-" <> "#{todo.id}"}
             class={hide_deleted(todo, "container")}>
               <.func_attach todo={todo} func={@todo_attach}/>
          </div>
        {/for}
      </div>
    """
  end

  defp hide_deleted(changeset, css_class) do
    if changeset.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

  defp func_attach(assigns) do
    if assigns.func do
       (assigns.func).(assigns)
    else
       edit_delete(assigns)
    end

  end

  def edit_delete(assigns) do
    ~F"""
    {@todo.description}
    <Link label="Edit" to="#" click="todo_form" values={todo_id: @todo.id, action: :edit, cid: todo_form_cid()} />
    <Link label="Delete" to="#" click="todo_form" values={todo_id: @todo.id, action: :delete} />
    """
  end

end

