defmodule QukathWeb.OrgstructLive.OrgstructItem do
  use Surface.Component

  alias Surface.Components.Link
  alias QukathWeb.OrgstructLive.NestedOrgstruct


  import QukathWeb.OrgstructLive.OrgstructIndex, only: [orgstruct_form_cid: 0]


  prop show, :boolean, default: true
  prop orgstruct, :any, default: nil
  prop nested_orgstruct, :any, required: true


end
