defmodule MyGroupCollectRegister.Commands.SubmitAccountHolderProfile do
  use Ash.Resource, domain: MyGroupCollectRegister.Domain

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
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
