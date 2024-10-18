defmodule MyGroupCollectRegister.Commands.Router do
  use Commanded.Commands.Router

  alias MyGroupCollectRegister.Commands.CreateAnAccount

  defstruct [:account_id]

  dispatch(CreateAnAccount, to: __MODULE__, identity: :account_id)

  def execute(_state, %CreateAnAccount{} = command) do
    %{
      account_id: account_id,
      email: email,
      password: password,
      agree_to_terms?: agree_to_terms?,
    } = command

    params = %{
      account_id: account_id,
      email: email,
      password: password,
      agree_to_terms?: agree_to_terms?,
    }

    {:ok, event} = MyGroupCollectRegister.Events.AccountCreated.create(params)
  end

  def apply(state, _event) do
    state
  end
end
