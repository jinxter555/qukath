defmodule QukathWeb.OrgstructLive.OrgstructIndexOrgstructs do
  use Surface.Component
  alias Surface.Components.Link
  prop orgstructs, :list, required: true
  prop socket, :any, required: true

  alias QukathWeb.OrgstructLive.OrgstructIndex
  alias Surface.Components.LiveRedirect
  alias QukathWeb.Router.Helpers, as: Routes                                                                                                                                                                 

  defp hide_deleted(orgstruct, css_class) do
    if orgstruct.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

  defp orgstruct_form_cid() do
    OrgstructIndex.orgstruct_form_cid()
  end


end

