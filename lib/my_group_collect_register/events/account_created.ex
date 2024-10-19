defmodule MyGroupCollectRegister.Events.AccountCreated do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  @derive {Jason.Encoder, only: [
    :account_id,
    :email,
    :password,
    :agree_to_terms?,
  ]}

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :email, :string, public?: true, allow_nil?: false
    # TODO: Encrypt password
    attribute :password, :string, public?: true, allow_nil?: false, constraints: [min_length: 8]
    attribute :agree_to_terms?, :boolean, public?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
      :email,
      :password,
      :agree_to_terms?,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
