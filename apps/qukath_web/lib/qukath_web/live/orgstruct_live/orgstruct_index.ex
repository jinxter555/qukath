defmodule QukathWeb.OrgstructLive.OrgstructIndex do
  use Surface.Component

  alias Surface.Components.Link

  prop orgstructs, :list, default: []

  defp orgstruct_form_cid() do 
    "ofb01"                   
  end                        

  defp orgstruct_hidden_class?(orgstruct, css_class) do
    if orgstruct.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

end
