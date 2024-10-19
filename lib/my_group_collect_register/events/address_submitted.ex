defmodule MyGroupCollectRegister.Events.AddressSubmitted do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  @derive {Jason.Encoder, only: [
    :account_id,
    :street,
    :city,
    :state,
    :zip,
    :country,
  ]}

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :street, :string, public?: true, allow_nil?: false
    attribute :city, :string, public?: true, allow_nil?: false
    attribute :state, :string, public?: true, allow_nil?: false
    attribute :zip, :string, public?: true, allow_nil?: false
    attribute :country, :string, public?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
      :street,
      :city,
      :state,
      :zip,
      :country,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
