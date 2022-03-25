defmodule QukathWeb.ResourceLive.ResourceFormBulma do
  use Surface.LiveComponent


  alias Qukath.Resources
  alias Qukath.Resources.{Resource}

  alias Surface.Components.Form
  #alias SurfaceBulma.Form.{HiddenInput, Submit}
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}

  data show, :boolean, default: false
  data action, :any, default: nil
  data changeset, :any

  @impl true
  def mount(socket) do
    changeset = Resources.change_resource(%Resource{})
    {:ok, socket
    |> assign(:changeset, changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        Resource
        </Header>

        <Form for={@changeset} change="validate" as={:resource} :let={form: f} submit="save">
          <TextInput label="Name" field={:name} placeholder="resource name" form={f}/>

          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:orgstruct_id} form={f} />

          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, _parent_socket) do
    changeset = Resources.change_resource(%Resource{
      orgstruct_id: params["orgstruct-id"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    resource = Resources.get_resource!(params["resource-id"]) 
    changeset =  Resources.change_resource(resource)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      resource: resource,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Resources.get_resource!(params["resource-id"]) 
    |> Resources.delete_resource()
    |> case do
      {:ok, _changeset} ->
        changeset = Resources.change_resource(%Resource{})
        {:noreply, socket 
          |> put_flash(:info, "Resource delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Resources.change_resource(%Resource{})
        {:noreply, socket 
          |> put_flash(:info, "Resource delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"resource" => params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Resources.change_resource(params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"resource" => params}, socket) do
    save_resource(socket, params["action"], params)
  end

  defp save_resource(socket, "edit", params) do
    Resources.update_resource(
      socket.assigns.resource,
      params) 
    |> case do
      {:ok, _resource} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_resource(socket, "new", params) do
    Resources.create_resource(params) 
    |> case do
      {:ok, _resource} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "resource created succeffuly") 
        }
      {:error, %Resource{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} ->
        IO.inspect changeset
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
