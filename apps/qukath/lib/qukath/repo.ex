defmodule Qukath.Repo do
  use Ecto.Repo,
    otp_app: :qukath,
    adapter: Ecto.Adapters.Postgres
end
