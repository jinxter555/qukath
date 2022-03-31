defmodule QukathWeb.ResourceLive.PermitFormBulma do
  use Surface.LiveComponent


  alias Qukath.Permits
  alias Qukath.Resources.{Permit}

  alias Surface.Components.Form
  #alias SurfaceBulma.Form.{HiddenInput, Submit}
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}

  prop resource_id, :any, required: true
  data show, :boolean, default: false
  data action, :any, default: nil
  data changeset, :any

  @impl true
  def mount(socket) do
    changeset = Permits.change_permit(%Permit{})
    {:ok, socket
    |> assign(:changeset, changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        Permit
        </Header>

        <Form for={@changeset} change="validate" as={:permit} :let={form: f} submit="save">
          <TextInput label="Action" field={:verb} placeholder="action verb" form={f}/>

          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:resource_id} value={@resource_id} form={f} />

          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, _parent_socket) do
    changeset = Permits.change_permit(%Permit{
      #resource_id: params["resource_id"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    IO.puts "permit edit"
    IO.inspect params
    permit = Permits.get_permit!(params["permit-id"]) #
    changeset =  Permits.change_permit(permit)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      permit: permit,
      show: true)
  end

  def apply_action("delete", params, socket) do 
    Permits.get_permit!(params["permit-id"])
    |> Permits.delete_permit()
    |> case do
      {:ok, _changeset} ->
        changeset = Permits.change_permit(%Permit{})
        {:noreply, socket 
          |> put_flash(:info, "Action Verb delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Permits.change_permit(%Permit{})
        {:noreply, socket 
          |> put_flash(:info, "Action verb delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"permit" => params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Permits.change_permit(params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"permit" => params}, socket) do
    IO.puts "save permit"
    IO.inspect params
    save_permit(socket, params["action"], params)
  end

  defp save_permit(socket, "edit", params) do
    Permits.update_permit(
      socket.assigns.permit,
      params) 
    |> case do
      {:ok, _permit} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_permit(socket, "new", params) do
    Permits.create_permit(params) 
    |> case do
      {:ok, _permit} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "permit created succeffuly") 
        }
      {:error, %Permit{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} ->
        IO.inspect changeset
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
