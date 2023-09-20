defmodule Summer.Repo do
  use Ecto.Repo,
    otp_app: :summer,
    adapter: Ecto.Adapters.Postgres
end
