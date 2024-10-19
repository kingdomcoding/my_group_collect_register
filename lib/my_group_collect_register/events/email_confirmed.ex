defmodule MyGroupCollectRegister.Events.EmailConfirmed do
  use Ash.Resource, domain: MyGroupCollectRegister.RegisterDomain

  @derive {Jason.Encoder, only: [
    :account_id,
  ]}

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
