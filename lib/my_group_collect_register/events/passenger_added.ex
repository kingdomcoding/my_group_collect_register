defmodule MyGroupCollectRegister.Events.PassengerAdded do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  @derive {Jason.Encoder, only: [
    :passenger_id,
    :trip_id,
    :account_id,
    :first_name,
    :middle_name_or_initial,
    :last_name,
    :preferred_name,
    :phone_number,
    :date_of_birth,
    :gender,
  ]}

  attributes do
    attribute :passenger_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :trip_id, :uuid, public?: true, allow_nil?: false
    attribute :account_id, :uuid, public?: true, allow_nil?: false
    # TODO: Encrypt PII
    attribute :first_name, :string, public?: true, allow_nil?: false
    attribute :middle_name_or_initial, :string, public?: true, allow_nil?: true
    attribute :last_name, :string, public?: true, allow_nil?: false
    attribute :preferred_name, :string, public?: true, allow_nil?: true
    attribute :phone_number, :string, public?: true, allow_nil?: true
    attribute :date_of_birth, :date, public?: true, allow_nil?: false
    attribute :gender, :atom, public?: true, allow_nil?: false, constraints: [one_of: [:male, :female, :x]]
  end

  actions do
    default_accept [
      :passenger_id,
      :trip_id,
      :account_id,
      :first_name,
      :middle_name_or_initial,
      :last_name,
      :preferred_name,
      :phone_number,
      :date_of_birth,
      :gender,
    ]

    defaults [:create]
  end

  code_interface do
    define :create
  end
end
