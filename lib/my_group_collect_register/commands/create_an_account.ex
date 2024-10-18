defmodule MyGroupCollectRegister.Commands.CreateAnAccount do
  use Ash.Resource, domain: MyGroupCollectRegister.RegisterDomain

  attributes do
    uuid_primary_key :account_id
    attribute :email, :string, public?: true, allow_nil?: false
    attribute :password, :string, public?: true, allow_nil?: false, constraints: [min_length: 8]
    attribute :agree_to_terms?, :boolean, public?: true, allow_nil?: false
  end

  validations do
    validate fn changeset, _context ->
      if Ash.Changeset.get_attribute(changeset, :agree_to_terms?) do
        :ok
      else
        {:error, field: :agree_to_terms?, message: "must agree to continue"}
      end
    end
  end

  actions do
    default_accept [
      :email,
      :password,
      :agree_to_terms?,
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
