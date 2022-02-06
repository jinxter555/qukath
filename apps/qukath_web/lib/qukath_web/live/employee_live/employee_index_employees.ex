defmodule QukathWeb.EmployeeLive.EmployeeIndexEmployees do
  use Surface.Component
  alias Surface.Components.Link
  prop employees, :list, required: true
  prop socket, :any, required: true

  alias QukathWeb.EmployeeLive.EmployeeIndex
  #alias Surface.Components.LiveRedirect
  #alias QukathWeb.Router.Helpers, as: Routes                                                                                                                                                                 

  defp hide_deleted(employee, css_class) do
    if employee.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end

 def employee_form_cid() do
    EmployeeIndex.employee_form_cid()
 end



end

