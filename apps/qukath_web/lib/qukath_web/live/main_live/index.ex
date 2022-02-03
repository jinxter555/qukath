defmodule QukathWeb.MainLive.Index do
  use Surface.LiveView

  alias Qukath.Orgstructs
  alias Surface.Components.Link

  alias QukathWeb.OrgstructLive.OrgstructFormBulma
  alias QukathWeb.OrgstructLive.OrgstructIndex

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, session, socket) do
    if connected?(socket), do: Orgstructs.subscribe()
    {:ok,
      socket
      |> assign(:orgstructs, list_orgstructs()),
      temporary_assigns: [orgstructs: []]
    }
  end

  @impl true
  def handle_event("orgstruct", params, socket) do
    OrgstructFormBulma.apply_action(params["action"], params, socket)
    {:noreply, socket}
  end


  @impl true
  def handle_info({:orgstruct_created, orgstruct}, socket) do
    IO.puts "handling info created"
    {:noreply, update(socket, :orgstructs, fn orgstructs ->
      [orgstruct | orgstructs]
    end)}
  end

  @impl true
  def handle_info({:orgstruct_updated, orgstruct}, socket) do
    IO.puts "handling info updated"
    #IO.inspect socket
    {:noreply, update(socket, :orgstructs, fn orgstructs ->
       [orgstruct | orgstructs]
    end)}
  end


  defp list_orgstructs do
    Orgstructs.list_orgstructs()
  end


  defp orgstruct_form_cid() do
    "ofb01"
  end


end


