defmodule MyGroupCollectRegister.RegisterDomain do
  use Ash.Domain

  resources do
    resource MyGroupCollectRegister.Commands.CreateAnAccount
  end
end
