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

  calculations do
    calculate :full_legal_name, :string, fn records, _context ->
      names = Enum.map(records, fn %{first_name: first_name, middle_name_or_initial: middle_name_or_initial, last_name: last_name} = record ->
        if middle_name_or_initial && middle_name_or_initial != "" do
          "#{first_name} #{middle_name_or_initial} #{last_name}"
        else
          "#{first_name} #{last_name}"
        end
      end)

      {:ok, names}
    end

    calculate :age_class, :string, fn records, _context ->
      age_classes = Enum.map(records, fn record ->
        if is_adult(record.date_of_birth) do
          "Adult"
        else
          "Child"
        end
      end)

      {:ok, age_classes}
    end
  end

  changes do
    change load(:full_legal_name)
    change load(:age_class)
  end

  preparations do
    prepare fn query, _context ->
      Ash.Query.load(query, [:full_legal_name, :age_class])
    end
  end

  postgres do
    repo MyGroupCollectRegister.Repo
    table "passengers"
  end

  def is_adult(date_of_birth) do
    date_18_years_ago = Timex.today() |> Timex.shift(years: -18)

    # if date_of_birth does not comes after date_18_years_ago
    Timex.compare(date_of_birth, date_18_years_ago) != 1
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

    read :get_by_account_and_trip do
      argument :account_id, :uuid, allow_nil?: false
      argument :trip_id, :uuid, allow_nil?: false

      filter expr(account_id == ^arg(:account_id))
      filter expr(trip_id == ^arg(:trip_id))
    end
  end

  code_interface do
    define :create
    define :get_by_account_and_trip, args: [:account_id, :trip_id]
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
