defmodule MyGroupCollectRegister.Commands.Router do
  use Commanded.Commands.Router

  alias MyGroupCollectRegister.Commands.{
    CreateAnAccount,
    ConfirmEmail,
    ConfirmAdult,
    SubmitAccountHolderProfile,
    SubmitAddress,
    AddPassenger,
  }

  defstruct [:account_id]

  dispatch(CreateAnAccount, to: __MODULE__, identity: :account_id)
  dispatch(ConfirmEmail, to: __MODULE__, identity: :account_id)
  dispatch(ConfirmAdult, to: __MODULE__, identity: :account_id)
  dispatch(SubmitAccountHolderProfile, to: __MODULE__, identity: :account_id)
  dispatch(SubmitAddress, to: __MODULE__, identity: :account_id)
  dispatch(AddPassenger, to: __MODULE__, identity: :account_id)

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

    {:ok, _event} = MyGroupCollectRegister.Events.AccountCreated.create(params)
  end

  def execute(_state, %ConfirmEmail{account_id: account_id} = _command) do
    {:ok, _event} = MyGroupCollectRegister.Events.EmailConfirmed.create(%{account_id: account_id})
  end

  def execute(_state, %ConfirmAdult{account_id: account_id, date_of_birth: date_of_birth} = _command) do
    {:ok, _event} = MyGroupCollectRegister.Events.AdultConfirmed.create(%{account_id: account_id, date_of_birth: date_of_birth})
  end

  def execute(_state, %SubmitAccountHolderProfile{} = command) do
    %{
      account_id: account_id,
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number,
    } = command

    params = %{
      account_id: account_id,
      first_name: first_name,
      last_name: last_name,
      phone_number: phone_number,
    }

    {:ok, _event} = MyGroupCollectRegister.Events.AccountHolderProfileSubmitted.create(params)
  end

  def execute(_state, %SubmitAddress{} = command) do
    %{
      account_id: account_id,
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
    } = command

    params = %{
      account_id: account_id,
      street: street,
      city: city,
      state: state,
      zip: zip,
      country: country,
    }

    {:ok, _event} = MyGroupCollectRegister.Events.AddressSubmitted.create(params)
  end

  def execute(_state, %AddPassenger{} = command) do
    %{
      trip_id: trip_id,
      passenger_id: passenger_id,
      account_id: account_id,
      first_name: first_name,
      middle_name_or_initial: middle_name_or_initial,
      last_name: last_name,
      preferred_name: preferred_name,
      phone_number: phone_number,
      date_of_birth: date_of_birth,
      gender: gender,
    } = command

    params = %{
      trip_id: trip_id,
      passenger_id: passenger_id,
      account_id: account_id,
      first_name: first_name,
      middle_name_or_initial: middle_name_or_initial,
      last_name: last_name,
      preferred_name: preferred_name,
      phone_number: phone_number,
      date_of_birth: date_of_birth,
      gender: gender,
    }

    {:ok, _event} = MyGroupCollectRegister.Events.PassengerAdded.create(params)
  end

  def apply(state, _event) do
    state
  end
end
