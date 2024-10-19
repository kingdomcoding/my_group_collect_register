defmodule MyGroupCollectRegister.Commands.ConfirmEmail do
  use Ash.Resource, domain: MyGroupCollectRegister.RegisterDomain

  attributes do
    attribute :account_id, :uuid, primary_key?: true, allow_nil?: false
  end

  actions do
    default_accept [
      :account_id,
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
