defmodule QukathWeb.MainLive.Index do
  use Surface.LiveView

  alias QukathWeb.Router.Helpers, as: Routes
  alias Surface.Components.{Link, LiveRedirect}
  alias Phoenix.LiveView.JS


  alias Qukath.Orgstructs

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
      socket 
      |> assign(:orgstruct, Orgstructs.get_orgstruct!(1))
    }
  end

end


