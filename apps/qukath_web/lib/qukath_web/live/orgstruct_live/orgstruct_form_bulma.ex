defmodule QukathWeb.OrgstructLive.OrgstructFormBulma do
  use Surface.LiveComponent


  alias Qukath.Orgstructs
  alias Qukath.Organizations.Orgstruct

  alias Surface.Components.Form
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}


  data orgstruct_id, :any, default: nil  # orgstruct_id goes to EntityMember parent
  data show, :boolean, default: false
  data action, :any, default: nil
  data employee_entity_id, :any, default: nil
  data changeset, :any


  @impl true
  def mount(socket) do
    changeset = Orgstructs.change_orgstruct(%Orgstruct{})
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

        <Form for={@changeset} change="validate" as={:orgstruct} :let={form: f} submit="save">
          <div class="control">
            <TextInput label="Name" field={:name} form={f}/>
          </div>
          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:type} form={f} />
          <HiddenInput field={:orgstruct_id} value={@orgstruct_id} form={f} />
          <HiddenInput field={:leader_entity_id} form={f} />
          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, parent_socket) do
    IO.puts "bulma form new"
    IO.inspect params

    changeset = Orgstructs.change_orgstruct(%Orgstruct{
      leader_entity_id: parent_socket.assigns.employee_entity_id,
      type: params["type"],
    })
    
    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      orgstruct_id: params["orgstruct-id"], # goes EntityMember parent
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    IO.puts "bulma form edit"
    IO.inspect params
    orgstruct = Orgstructs.get_orgstruct!(params["orgstruct-id"]) 
    changeset =  Orgstructs.change_orgstruct(orgstruct)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      orgstruct: orgstruct,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Orgstructs.get_orgstruct!(params["orgstruct-id"]) 
    |> Orgstructs.delete_orgstruct()
    |> case do
      {:ok, _changeset} ->
        changeset = Orgstructs.change_orgstruct(%Orgstruct{})
        {:noreply, socket 
          |> put_flash(:info, "orgstruct delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Orgstructs.change_orgstruct(%Orgstruct{})
        {:noreply, socket 
          |> put_flash(:info, "orgstruct delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end


  @impl true
  def handle_event("validate", %{"orgstruct" => orgstruct_params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Orgstructs.change_orgstruct(orgstruct_params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"orgstruct" => orgstruct_params}, socket) do
    save_orgstruct(socket, orgstruct_params["action"], orgstruct_params)
  end

  defp save_orgstruct(socket, "edit", orgstruct_params) do
    Orgstructs.update_orgstruct(
      socket.assigns.orgstruct,
      orgstruct_params) 
    |> case do
      {:ok, _orgstruct} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_orgstruct(socket, "new", orgstruct_params) do
    case Orgstructs.create_orgstruct(orgstruct_params) do
      {:ok, _orgstruct} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "orgstruct created succeffuly") 
        }
      {:error, %Orgstruct{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
