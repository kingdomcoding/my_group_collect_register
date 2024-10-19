defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AddPassengerForm.Fields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :first_name, :string, public?: true, allow_nil?: false
    attribute :middle_name_or_initial, :string, public?: true, allow_nil?: true
    attribute :last_name, :string, public?: true, allow_nil?: false
    attribute :preferred_name, :string, public?: true, allow_nil?: true
    attribute :phone_number, :string, public?: true, allow_nil?: true
    attribute :date_of_birth, :date, public?: true, allow_nil?: false
    attribute :gender, :atom, public?: true, allow_nil?: false, constraints: [one_of: [:male, :female, :x]]
  end

  validations do

    validate fn changeset, _context ->
      if date_of_birth = Ash.Changeset.get_attribute(changeset, :date_of_birth) do
        if is_adult(date_of_birth) do
          phone_number = Ash.Changeset.get_attribute(changeset, :phone_number)

          if phone_number && phone_number != "" do
            :ok
          else
            {:error, field: :phone_number, message: "required for adults"}
          end
        else
          :ok
        end
      else
        :ok
      end
    end
  end

  def is_adult(date_of_birth) do
    date_18_years_ago = Timex.today() |> Timex.shift(years: -18)

    # if date_of_birth does not comes after date_18_years_ago
    Timex.compare(date_of_birth, date_18_years_ago) != 1
  end


  actions do
    create :submit
  end
end
