defmodule QukathWeb.AuthUser do
  import Phoenix.LiveView

  alias Qukath.Accounts
  alias Qukath.Repo


  
  def on_mount(_, _params, session,  socket) do
    user = Accounts.get_user_by_session_token(session["user_token"]) 
           |> Repo.preload([employees: [:entity]])
    employee = hd(user.employees)

    {:cont, 
      socket 
      |> assign(:current_user, user)
      |> assign(:employee_entity_id, employee.entity.id)
    }
  end

  def get_current_employee(socket) do
    user = Accounts.get_user!(socket.assigns.current_user.id)
    |> Repo.preload([employees: [:entity]])
    case user.employees do
      [] ->  nil
      _ -> hd(user.employees)
    end
  end
end
