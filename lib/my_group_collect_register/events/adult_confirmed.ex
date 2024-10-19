defmodule MyGroupCollectRegister.Events.AdultConfirmed do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  @derive {Jason.Encoder, only: [
    :account_id,
    :date_of_birth,
  ]}

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :date_of_birth, :date, public?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
      :date_of_birth,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
