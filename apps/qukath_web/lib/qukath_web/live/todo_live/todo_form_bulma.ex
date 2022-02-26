defmodule QukathWeb.TodoLive.TodoFormBulma do
  use Surface.LiveComponent


  alias Qukath.Work
  alias Qukath.Work.{Todo, TodoInfo}

  alias Surface.Components.Form
  #alias SurfaceBulma.Form.{HiddenInput, Submit}
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}

  data show, :boolean, default: false
  data action, :any, default: nil
  data changeset, :any
  data info_changeset, :any
  data employee_entity_id, :any, default: nil
  prop parent_assigns, :any, default: nil

  @impl true
  def mount(socket) do
    changeset = Work.change_todo(%Todo{})
    info_changeset = Work.change_todo_info(%TodoInfo{})
    {:ok, socket
    |> assign(:changeset, changeset)
    |> assign(:info_changeset, info_changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        headertext
        </Header>

        <Form for={@changeset} change="validate" as={:todo} :let={form: f} submit="save">
          <TextInput label="Description" field={:description} placeholder="Todo description" form={f}/>
          <TextInput label="Name" field={:name} placeholder="Todo name" form={f}/>

          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:orgstruct_id} form={f} />
          <HiddenInput field={:employee_entity_id} value={@employee_entity_id} form={f} />
          <HiddenInput field={:type} form={f} />

          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, _parent_socket) do
    changeset = Work.change_todo(%Todo{
      orgstruct_id: params["orgstruct-id"],
      type: params["type"],
    })
    info_changeset = Work.change_todo_info(%TodoInfo{})

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      employee_entity_id: params["employee-entity-id"],
      changeset: changeset,
      info_changeset: info_changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    todo = Work.get_todo!(params["todo-id"]) 
    changeset =  Work.change_todo(todo)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      todo: todo,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Work.get_todo!(params["todo-id"]) 
    |> Work.delete_todo()
    |> case do
      {:ok, _changeset} ->
        changeset = Work.change_todo(%Todo{})
        {:noreply, socket 
          |> put_flash(:info, "Todo delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Work.change_todo(%Todo{})
        {:noreply, socket 
          |> put_flash(:info, "todo delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"todo" => params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Work.change_todo(params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"todo" => params}, socket) do
    #{:noreply, assign(socket, show: false)}
    save_todo(socket, params["action"], params)
  end

  defp save_todo(socket, "edit", params) do
    Work.update_todo(
      socket.assigns.todo,
      params) 
    |> case do
      {:ok, _todo} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_todo(socket, "new", params) do
    params_with_sholders(params)
    |> Work.create_todo() 
    |> case do
      {:ok, _orgstruct} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "todo created succeffuly") 
        }
      {:error, %Todo{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp params_with_sholders(params) do
    Map.merge(params, %{"sholder" => [
      %{"type" => "owner",
        "entity_id" => params["employee_entity_id"]},
      %{"type" => "createdby",
        "entity_id" => params["employee_entity_id"]},
      %{"type" => "assignedby",
        "entity_id" => params["employee_entity_id"]},
      %{"type" => "assignedto",
        "entity_id" => params["employee_entity_id"]},
    ]})
  end

end
