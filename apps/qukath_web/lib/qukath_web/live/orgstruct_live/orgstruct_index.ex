defmodule QukathWeb.OrgstructLive.OrgstructIndex do
  use Surface.Component

  alias Surface.Components.Link

  prop orgstructs, :list, default: []

  defp orgstruct_form_cid() do                                                                                                                                                                                 
    "ofb01"                                                                                                                                                                                                    
  end                                                                                                                                                                                                          

end
