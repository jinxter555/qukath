defmodule QukathWeb.OrgstructLive.OrgstructIndexOrgstructs do
  use Surface.Component

  alias Surface.Components.Link
  alias Surface.Components.LiveRedirect
  alias QukathWeb.Router.Helpers, as: Routes

  import QukathWeb.OrgstructLive.OrgstructIndex, only: [orgstruct_form_cid: 0]

  prop orgstructs, :list, required: true
  prop socket, :any, required: true
  prop show, :boolean, default: true


  defp hide_deleted(orgstruct, css_class) do
    if orgstruct.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

end

