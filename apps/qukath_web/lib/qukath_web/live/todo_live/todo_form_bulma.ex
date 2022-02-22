defmodule QukathWeb.TodoLive.TodoFormBulma do
  use Surface.LiveComponent


  alias Qukath.Work
  alias Qukath.Work.Todo

  alias Surface.Components.Form
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}

  data show, :boolean, default: false
  data action, :any, default: nil
  data changeset, :any

  @impl true
  def mount(socket) do
    changeset = Work.change_todo(%Todo{})
    {:ok, socket
    |> assign(:changeset, changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        headertext
        </Header>

        <Form for={@changeset} change="validate" as={:todo} :let={form: f} submit="save">
          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:orgstruct_id} form={f} />
          <HiddenInput field={:type} form={f} />
          <HiddenInput field={:state} form={f} />
          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, parent_socket) do
    changeset = Work.change_todo(%Todo{
      orgstruct_id: params["orgstruct-id"],
      type: params["type"],
      state: params["state"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
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
    {:noreply, assign(socket, show: false)}
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
    case Work.create_todo(params) do
      {:ok, _orgstruct} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "todo created succeffuly") 
        }
      {:error, %Todo{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
