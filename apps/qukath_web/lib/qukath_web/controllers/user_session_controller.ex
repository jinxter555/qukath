defmodule QukathWeb.UserSessionController do
  use QukathWeb, :controller

  alias Qukath.Accounts
  alias Qukath.Repo
  alias QukathWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = (Accounts.get_user_by_email_and_password(email, password)
              |> Repo.preload([:employees])) do
      UserAuth.log_in_user(conn, user, user_params)
    else
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
