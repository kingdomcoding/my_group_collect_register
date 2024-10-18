defmodule MyGroupCollectRegister.Repo do
  use Ecto.Repo,
    otp_app: :my_group_collect_register,
    adapter: Ecto.Adapters.Postgres
end
