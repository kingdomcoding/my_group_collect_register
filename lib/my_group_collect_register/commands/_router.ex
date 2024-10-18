defmodule MyGroupCollectRegister.Commands.Router do
  use Commanded.Commands.Router

  alias MyGroupCollectRegister.Commands.CreateAnAccount

  defstruct [:account_id]

  dispatch(CreateAnAccount, to: __MODULE__, identity: :account_id)

  def execute(_state, %CreateAnAccount{} = command) do
    # TODO: Emit event

    {:ok, []}
  end

  def apply(state, _event) do
    state
  end
end
