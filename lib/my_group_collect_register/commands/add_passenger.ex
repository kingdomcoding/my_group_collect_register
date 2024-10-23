defmodule MyGroupCollectRegister.Commands.AddPassenger do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  attributes do
    uuid_primary_key :passenger_id
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

  actions do
    default_accept [
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

    create :dispatch_command do
      change fn changeset, _context ->
        Ash.Changeset.after_action(changeset, fn changeset, command ->
          with :ok <- MyGroupCollectRegister.Application.dispatch(command) do
            {:ok, command}
          end
        end)
      end
    end
  end

  code_interface do
    define :dispatch_command
  end
end
