defmodule QukathWeb.RoleLive.RoleFormBulma do
  use Surface.LiveComponent


  alias Qukath.Roles
  alias Qukath.Roles.{Role}

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
    changeset = Roles.change_role(%Role{})
    {:ok, socket
    |> assign(:changeset, changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        Role
        </Header>

        <Form for={@changeset} change="validate" as={:role} :let={form: f} submit="save">
          <TextInput label="Name" field={:name} placeholder="role name" form={f}/>

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
    changeset = Roles.change_role(%Role{
      orgstruct_id: params["orgstruct-id"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    role = Roles.get_role!(params["role-id"]) 
    changeset =  Roles.change_role(role)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      role: role,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Roles.get_role!(params["role-id"]) 
    |> Roles.delete_role()
    |> case do
      {:ok, _changeset} ->
        changeset = Roles.change_role(%Role{})
        {:noreply, socket 
          |> put_flash(:info, "Role delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Roles.change_role(%Role{})
        {:noreply, socket 
          |> put_flash(:info, "role delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"role" => params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Roles.change_role(params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"role" => params}, socket) do
    save_role(socket, params["action"], params)
  end

  defp save_role(socket, "edit", params) do
    Roles.update_role(
      socket.assigns.role,
      params) 
    |> case do
      {:ok, _role} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_role(socket, "new", params) do
    Roles.create_role(params) 
    |> case do
      {:ok, _role} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "role created succeffuly") 
        }
      {:error, %Role{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} ->
        IO.inspect %Role{}
        IO.inspect changeset
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
