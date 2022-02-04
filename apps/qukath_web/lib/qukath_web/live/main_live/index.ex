defmodule QukathWeb.MainLive.Index do
  use Surface.LiveView

  alias QukathWeb.OrgstructLive.OrgstructIndex

  on_mount QukathWeb.AuthUser

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket }
  end

end


