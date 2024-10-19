defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AccountHolderProfileForm.Fields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :first_name, :string, public?: true, allow_nil?: false
    attribute :last_name, :string, public?: true, allow_nil?: false
    attribute :phone_number, :string, public?: true, allow_nil?: false
  end

  actions do
    create :submit
  end
end
