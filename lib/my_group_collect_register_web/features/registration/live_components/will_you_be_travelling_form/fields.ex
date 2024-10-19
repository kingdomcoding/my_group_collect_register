defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.WillYouBeTravellingForm.Fields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :will_you_be_travelling?, :atom, public?: true, allow_nil?: false, constraints: [one_of: [:yes, :no]]
  end

  actions do
    create :submit
  end
end
