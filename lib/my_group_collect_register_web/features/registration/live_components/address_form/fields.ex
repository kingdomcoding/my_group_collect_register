defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AddressForm.Fields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :street, :string, public?: true, allow_nil?: false
    attribute :city, :string, public?: true, allow_nil?: false
    attribute :state, :string, public?: true, allow_nil?: false
    attribute :zip, :string, public?: true, allow_nil?: false
    attribute :country, :string, public?: true, allow_nil?: false
  end

  actions do
    create :submit
  end
end
