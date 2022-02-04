#
alias Qukath.Accounts
alias Qukath.Employees
alias Qukath.Orgstructs
alias Qukath.Repo
import Qukath.Factory

# insert_list(10, :orgstruct, %{leader_entity_id: u1.})

{:ok, u1} = Accounts.register_user(%{ email: "jt@example.com", password: "12345678", password_confirmation: "12345678" })
{:ok, u2} = Accounts.register_user(%{ email: "jt2@example.com", password: "12345678", password_confirmation: "12345678" }) 
{:ok, u3} = Accounts.register_user(%{ email: "jt3@example.com", password: "12345678", password_confirmation: "12345678" })


{:ok, orgstruct1} = Orgstructs.create_orgstruct_init(u1.id, %{"name" => "company 1", "type" => "company"}, "jj boss")
{:ok, orgstruct2} = Orgstructs.create_orgstruct_init(u2.id, %{"name" => "my com 2", "type" => "company"}, "u 2")
{:ok, orgstruct3} = Orgstructs.create_orgstruct_init(u3.id, %{"name" => "her compan 3", "type" => "company"}, "u 3")

employee1 = Employees.get_employees_by_user_id!(u1.id) |> Repo.preload([:entity]) |> hd
insert_list(10, :orgstruct, %{leader_entity_id: employee1.entity.id})

insert_list(10, :employee,  %{orgstruct_id: orgstruct1.id})
insert_list(10, :employee,  %{orgstruct_id: orgstruct2.id})
insert_list(10, :employee,  %{orgstruct_id: orgstruct3.id})

