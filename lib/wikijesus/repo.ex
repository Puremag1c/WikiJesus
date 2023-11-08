defmodule Wikijesus.Repo do
  use Ecto.Repo,
    otp_app: :wikijesus,
    adapter: Ecto.Adapters.Postgres
end
