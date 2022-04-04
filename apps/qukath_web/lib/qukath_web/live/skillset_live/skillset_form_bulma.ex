defmodule QukathWeb.SkillsetLive.SkillsetFormBulma do
  use Surface.LiveComponent


  alias Qukath.Skillsets
  alias Qukath.Roles.{Skillset}

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
    changeset = Skillsets.change_skillset(%Skillset{})
    {:ok, socket
    |> assign(:changeset, changeset)
    }
  end
  
  def render(assigns) do
    ~F"""
      <Card show={@show} close_event="modal_close" show_close_button={true}>
        <Header>
        Skillset
        </Header>

        <Form for={@changeset} change="validate" as={:skillset} :let={form: f} submit="save">
          <TextInput label="Name" field={:name} placeholder="skillset name" form={f}/>

          <HiddenInput field={:action} value={@action} form={f} />
          <HiddenInput field={:role_id} form={f} />

          <Submit type="Submit"> Save </Submit>
        </Form>

        <Footer>
        </Footer>
    </Card>
    """
  end


  def apply_action("new", params, _parent_socket) do
    changeset = Skillsets.change_skillset(%Skillset{
      role_id: params["role-id"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    skillset = Skillsets.get_skillset!(params["skillset-id"]) 
    changeset =  Skillsets.change_skillset(skillset)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      skillset: skillset,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Skillsets.get_skillset!(params["skillset-id"]) 
    |> Skillsets.delete_skillset()
    |> case do
      {:ok, _changeset} ->
        changeset = Skillsets.change_skillset(%Skillset{})
        {:noreply, socket 
          |> put_flash(:info, "Skillsets delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Skillsets.change_skillset(%Skillset{})
        {:noreply, socket 
          |> put_flash(:info, "Skillsets delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"skillset" => params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Skillsets.change_skillset(params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"skillset" => params}, socket) do
    save_skillset(socket, params["action"], params)
  end

  defp save_skillset(socket, "edit", params) do
    Skillsets.update_skillset(
      socket.assigns.skillset,
      params) 
    |> case do
      {:ok, _skillset} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_skillset(socket, "new", params) do
    Skillsets.create_skillset(params) 
    |> case do
      {:ok, _skillset} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "skillset created succeffuly") 
        }
      {:error, %Skillset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
      {:error, changeset} ->
        IO.inspect %Skillset{}
        IO.inspect changeset
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

end
