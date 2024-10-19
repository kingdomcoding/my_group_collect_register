defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.CreateAnAccountForm.Fields do
  use Ash.Resource, data_layer: :embedded

  attributes do
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
    create :submit
  end
end
