defmodule MyGroupCollectRegister.RegisterDomain do
  use Ash.Domain

  resources do
    resource MyGroupCollectRegister.Commands.CreateAnAccount
    resource MyGroupCollectRegister.Commands.ConfirmEmail

    resource MyGroupCollectRegister.Events.AccountCreated
    resource MyGroupCollectRegister.Events.EmailConfirmed
  end
end
