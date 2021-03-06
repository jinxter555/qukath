defmodule QukathWeb.Router do
  use QukathWeb, :router

  import Surface.Catalogue.Router

  import QukathWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {QukathWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", QukathWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/", PageController, :index
    live "/demo", Demo


    live "/main", MainLive.Index, :index
    live "/example", Example

    live "/orgstructs", OrgstructLive.Index, :index
    live "/orgstructs/:id", OrgstructLive.Show, :show
    live "/orgstructs/:orgstruct_id/members_members", OrgstructLive.MembersMembers, :members

    #live "/orgstructs/:orgstruct_id/add_members", OrgstructLive.AddMembers, :add_members

    live "/orgstructs/:type/type", OrgstructLive.Index, :index_type

    live "/orgstructs/:orgstruct_id/employees", EmployeeLive.Index, :orgstruct
    live "/orgstructs/:orgstruct_id/todos", TodoLive.Index, :orgstruct
    live "/orgstructs/:orgstruct_id/roles", RoleLive.Index, :orgstruct
    live "/orgstructs/:orgstruct_id/resources", ResourceLive.Index, :orgstruct
    live "/orgstructs/:orgstruct_id/employee_roles", RoleLive.EmployeeRoles, :orgstruct

    #live "/orgstructs/:src_orgstruct_id/:tgt_orgstruct_id/members", EmployeeLive.Members, :add_members
    #live "/orgstructs/:src_orgstruct_id/:tgt_orgstruct_id/members_to_members", EmployeeLive.Members, :members_to_members

    live "/employees", EmployeeLive.Index, :index        
    live "/employees/:id", EmployeeLive.Show, :show
    live "/employees/:employee_id/todos", EmptdLive.Index, :index
    live "/employees/:employee_id/roles", EmployeeRolesLive.IndexRoles, :index

    live "/roles/:id", RoleLive.Show, :show
    live "/roles/:role_id/skillset", SkillsetLive.Index, :index

    live "/resources/:id", ResourceLive.Show, :show
    live "/skillset/:id", SkillsetLive.Show, :show

    #live "/employees/:orgstruct_id/orgstruct", EmployeeLive.Index, :orgstruct

    #live "/employees/:src_orgstruct_id/:tgt_orgstruct_id/employees", EmployeeLive.Employees, :employees # company employees to department,team.. members
    #live "/employees/:src_orgstruct_id/:tgt_orgstruct_id/members", EmployeeLive.Members, :members  # department members to team

    live "/todos", TodoLive.Index, :index
    live "/todos/:id", TodoLive.Show, :show

    #live "/todos/:orgstruct_id/orgstruct", TodoLive.Index, :orgstruct


  end

  # Other scopes may use custom stacks.
  # scope "/api", QukathWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: QukathWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", QukathWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", QukathWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", QukathWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      surface_catalogue "/catalogue"
    end
  end
end
