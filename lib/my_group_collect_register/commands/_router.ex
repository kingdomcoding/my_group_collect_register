defmodule MyGroupCollectRegister.Commands.Router do
  use Commanded.Commands.Router

  alias MyGroupCollectRegister.Commands.{
    CreateAnAccount,
    ConfirmEmail,
    ConfirmAdult,
  }

  defstruct [:account_id]

  dispatch(CreateAnAccount, to: __MODULE__, identity: :account_id)
  dispatch(ConfirmEmail, to: __MODULE__, identity: :account_id)
  dispatch(ConfirmAdult, to: __MODULE__, identity: :account_id)

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

  def execute(_state, %ConfirmEmail{account_id: account_id} = command) do
    {:ok, event} = MyGroupCollectRegister.Events.EmailConfirmed.create(%{account_id: account_id})
  end

  def execute(_state, %ConfirmAdult{account_id: account_id, date_of_birth: date_of_birth} = command) do
    {:ok, event} = MyGroupCollectRegister.Events.AdultConfirmed.create(%{account_id: account_id, date_of_birth: date_of_birth})
  end

  def apply(state, _event) do
    state
  end
end
