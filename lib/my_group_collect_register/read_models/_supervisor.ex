defmodule MyGroupCollectRegister.ReadModels.Supervisor do
  use Supervisor

  def init(_init_arg) do
    children = [
      MyGroupCollectRegister.ReadModels.Passengers,
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end
end
