defmodule Qukath.Repo do
  use Ecto.Repo,
    otp_app: :qukath,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 3
end
