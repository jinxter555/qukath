defmodule QukathWeb.MainLive.Index do
  use Surface.LiveView

  alias Qukath.Orgstructs
  alias Surface.Components.Link

  alias QukathWeb.OrgstructLive.OrgstructFormBulma

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    IO.puts "main live index"
    IO.inspect socket
    {:ok,
      socket
      |> assign(:orgstructs, list_orgstructs())
    }
  end

  @impl true
  def handle_event("orgstruct", params, socket) do
    OrgstructFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end

  defp list_orgstructs do
    Orgstructs.list_orgstructs()
  end


  defp orgstruct_form_cid() do
    "ofb01"
  end


end


