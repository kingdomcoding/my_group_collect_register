defmodule MyGroupCollectRegister.Commands.SubmitAddress do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

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
