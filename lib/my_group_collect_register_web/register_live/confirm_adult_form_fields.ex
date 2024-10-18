defmodule MyGroupCollectRegisterWeb.RegisterLive.ConfirmAdultFormFields do
  use Ash.Resource, data_layer: :embedded

  attributes do
    attribute :date_of_birth, :date, public?: true, allow_nil?: false
  end

  validations do

    validate fn changeset, _context ->
      if date_of_birth = Ash.Changeset.get_attribute(changeset, :date_of_birth) do
        date_18_years_ago = Timex.today() |> Timex.shift(years: -18)

        # if date_of_birth comes after date_18_years_ago
        if Timex.compare(date_of_birth, date_18_years_ago) == 1 do
          {:error, field: :date_of_birth, message: "must be 18 or older"}
        else
          :ok
        end
      else
        :ok
      end
    end
  end


  actions do
    create :submit
  end
end
