defmodule MyGroupCollectRegister.Events.AccountHolderProfileSubmitted do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  @derive {Jason.Encoder, only: [
    :account_id,
    :first_name,
    :last_name,
    :phone_number,
  ]}

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
    # TODO: Encrypt PII
    attribute :first_name, :string, public?: true, allow_nil?: false
    attribute :last_name, :string, public?: true, allow_nil?: false
    attribute :phone_number, :string, public?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
      :first_name,
      :last_name,
      :phone_number,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
