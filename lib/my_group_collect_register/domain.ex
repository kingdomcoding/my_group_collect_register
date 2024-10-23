defmodule MyGroupCollectRegister.Domain do
  use Ash.Domain

  resources do
    resource MyGroupCollectRegister.Commands.CreateAnAccount
    resource MyGroupCollectRegister.Commands.ConfirmEmail
    resource MyGroupCollectRegister.Commands.ConfirmAdult
    resource MyGroupCollectRegister.Commands.SubmitAccountHolderProfile
    resource MyGroupCollectRegister.Commands.SubmitAddress
    resource MyGroupCollectRegister.Commands.AddPassenger

    resource MyGroupCollectRegister.Events.AccountCreated
    resource MyGroupCollectRegister.Events.EmailConfirmed
    resource MyGroupCollectRegister.Events.AdultConfirmed
    resource MyGroupCollectRegister.Events.AccountHolderProfileSubmitted
    resource MyGroupCollectRegister.Events.AddressSubmitted
    resource MyGroupCollectRegister.Events.PassengerAdded
  end
end
