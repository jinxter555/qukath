defmodule QukathWeb.EmployeeLive.EmployeeIndexEmployees do
  use Surface.Component

  import QukathWeb.EmployeeLive.EmployeeIndex, only: [employee_form_cid: 0]

  alias Surface.Components.Link

  prop employees, :list, required: true
  prop socket, :any, required: true


  defp hide_deleted(employee, css_class) do
    if employee.__meta__.state == :deleted do
      css_class <> " is-hidden"
    else
      css_class
    end
  end


end

