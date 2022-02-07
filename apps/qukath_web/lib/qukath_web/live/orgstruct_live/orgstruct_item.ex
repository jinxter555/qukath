defmodule QukathWeb.OrgstructLive.OrgstructItem do
  use Surface.Component

  alias Surface.Components.Link


  import QukathWeb.OrgstructLive.OrgstructIndex, only: [orgstruct_form_cid: 0]


  prop show, :boolean, default: true
  prop orgstruct, :any, default: nil

end
