defmodule MyGroupCollectRegister.ReadModels.Passengers do
  use Ash.Resource,
    domain: MyGroupCollectRegister.Domain,
    data_layer: AshPostgres.DataLayer

  attributes do
    attribute :passenger_id, :uuid, primary_key?: true, allow_nil?: false
    attribute :trip_id, :uuid, public?: true, allow_nil?: false
    attribute :account_id, :uuid, public?: true, allow_nil?: false
    attribute :first_name, :string, public?: true, allow_nil?: false
    attribute :middle_name_or_initial, :string, public?: true, allow_nil?: true
    attribute :last_name, :string, public?: true, allow_nil?: false
    attribute :preferred_name, :string, public?: true, allow_nil?: true
    attribute :phone_number, :string, public?: true, allow_nil?: true
    attribute :date_of_birth, :date, public?: true, allow_nil?: false
    attribute :gender, :atom, public?: true, allow_nil?: false, constraints: [one_of: [:male, :female, :x]]
  end

  postgres do
    repo MyGroupCollectRegister.Repo
    table "passengers"
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

    defaults [:create, :read]
  end

  code_interface do
    define :create
  end

  alias MyGroupCollectRegister.Events.PassengerAdded

  use Commanded.Event.Handler,
    application: MyGroupCollectRegister.Application,
    name: __MODULE__,
    consistency: :eventual

  def handle(%PassengerAdded{} = event, _metadata) do
    %{
      passenger_id: passenger_id,
      trip_id: trip_id,
      account_id: account_id,
      first_name: first_name,
      middle_name_or_initial: middle_name_or_initial,
      last_name: last_name,
      preferred_name: preferred_name,
      phone_number: phone_number,
      date_of_birth: date_of_birth,
      gender: gender,
    } = event

    params = %{
      passenger_id: passenger_id,
      trip_id: trip_id,
      account_id: account_id,
      first_name: first_name,
      middle_name_or_initial: middle_name_or_initial,
      last_name: last_name,
      preferred_name: preferred_name,
      phone_number: phone_number,
      date_of_birth: date_of_birth,
      gender: gender,
    }

    {:ok, _resource} = __MODULE__.create(params)
    :ok
  end
end
