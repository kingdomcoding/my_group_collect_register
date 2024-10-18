defmodule MyGroupCollectRegisterWeb.RegisterLive.Page1FormFields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :email, :string, public?: true, allow_nil?: false
    attribute :password, :string, public?: true, allow_nil?: false, constraints: [min_length: 8]
  end

  actions do
    create :submit
  end
end
