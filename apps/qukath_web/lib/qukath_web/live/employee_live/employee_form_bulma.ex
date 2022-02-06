defmodule QukathWeb.EmployeeLive.EmployeeFormBulma do
  use Surface.LiveComponent


  alias Qukath.Orgstructs
  alias Qukath.Employees
  alias Qukath.Organizations.Orgstruct
  alias Qukath.Organizations.Employee

  alias Surface.Components.Form
  alias SurfaceBulma.Form.{TextInput, HiddenInput, Submit}
  alias SurfaceBulma.Modal.Card                                                                    
  alias SurfaceBulma.Modal.{Card, Header, Footer}


  data show, :boolean, default: false
  data action, :any, default: nil
  data changeset, :any


  @impl true
  def mount(socket) do
    changeset = Employees.change_employee(%Employee{})
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

        <Form for={@changeset} change="validate" as={:employee} :let={form: f} submit="save">
          <div class="control">
            <TextInput label="Name" field={:name} form={f}/>
          </div>
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
    changeset = Employees.change_employee(%Employee{
      orgstruct_id: params["orgstruct-id"],
    })

    send_update(__MODULE__,
      id: params["cid"],
      action: :new,
      changeset: changeset,
      show: true)
  end

  def apply_action("edit", params, _parent_socket) do
    IO.puts "bulma form edit"
    IO.inspect params
    employee = Employees.get_employee!(params["employee-id"]) 
    changeset =  Employees.change_employee(employee)

    send_update(__MODULE__,
      id: params["cid"],
      action: params["action"],
      changeset: changeset,
      employee: employee,
      show: true)
  end

  def apply_action("delete", params, socket) do
    Employees.get_employee!(params["employee-id"]) 
    |> Employees.delete_employee()
    |> case do
      {:ok, _changeset} ->
        changeset = Employees.change_employee(%Employee{})
        {:noreply, socket 
          |> put_flash(:info, "employee delete succeffuly") 
          |> assign(:changeset, changeset)
        }
      error -> 
        changeset = Employees.change_employee(%Employee{})
        {:noreply, socket 
          |> put_flash(:info, "employee delete error: #{error}") 
          |> assign(:changeset, changeset)
        }
      end
  end

  @impl true
  def handle_event("validate", %{"employee" => employee_params}, socket) do
    changeset = 
      socket.assigns.changeset.data
      |> Employees.change_employee(employee_params)
      |> Map.put(:action, :validate)
    {:noreply, socket |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("modal_close", _params, socket) do
    {:noreply, assign(socket, show: false)}
  end

  @impl true
  def handle_event("save", %{"employee" => employee_params}, socket) do
    IO.puts "employee save"
    IO.inspect employee_params
    {:noreply, assign(socket, show: false)}
    save_employee(socket, employee_params["action"], employee_params)
  end

  defp save_employee(socket, "edit", employee_params) do
    Employees.update_employee(
      socket.assigns.employee,
      employee_params) 
    |> case do
      {:ok, _employee} ->
        {:noreply, socket
        |> assign(show: false)
        }
    end
  end

  defp save_employee(socket, "new", employee_params) do
    IO.puts "save new"
    IO.inspect employee_params

    case Employees.create_employee(employee_params) do
      {:ok, _orgstruct} ->
        {:noreply, socket
          |> assign(show: false)
          |> put_flash(:info, "employee created succeffuly") 
        }
      {:error, %Employee{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end


end
