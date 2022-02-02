#
alias Qukath.Accounts
alias Qukath.Employees
alias Qukath.Orgstructs
import Qukath.Factory

insert_list(10, :orgstruct)

{:ok, u} = Accounts.register_user(%{ email: "jt@example.com", password: "12345678", password_confirmation: "12345678" })

#{:ok, u1} = Accounts.register_user(%{ email: "jt1@example.com", password: "12345678", password_confirmation: "12345678" }) 
#{:ok, u2} = Accounts.register_user(%{ email: "jt2@example.com", password: "12345678", password_confirmation: "12345678" })

{:ok, c1} = Orgstructs.create_orgstruct_init(u.id, %{"name" => "company 1", "type" => "company"}, "jj boss")
