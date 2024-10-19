defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AddPassengerForm do
  use MyGroupCollectRegisterWeb, :live_component

  import MyGroupCollectRegisterWeb.Features.Registration.Components, only: [radio_group: 1]

  def update(%{account_id: account_id} = _assigns, socket) do
    form = AshPhoenix.Form.for_create(__MODULE__.Fields, :submit, domain: MyGroupCollectRegisterWeb.Features.Registration.Domain) |> to_form()

    socket =
      socket
      |> assign(:form, form)
      |> assign(:account_id, account_id)
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
          <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
              <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                  <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                      Passenger Details
                  </h1>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.input field={@form[:first_name]} label="First name" />
                      <.input field={@form[:middle_name_or_initial]} label="Middle name or initial (optional)" />
                      <.input field={@form[:last_name]} label="Last name" />
                      <.input field={@form[:preferred_name]} label="Preferred name (optional)" />
                      <.input field={@form[:phone_number]} label="Phone number (required for adults)" />
                      <.input field={@form[:date_of_birth]} label="Date of birth" type="date"/>
                      <.radio_group field={@form[:gender]} label="Gender"
                        options={[{"Male", "male"}, {"Female", "female"}, {"X", "x"}]}
                      />

                      <:actions>
                        <.button>Add</.button>
                      </:actions>
                  </.simple_form>
              </div>
          </div>
      </div>
    </section>
    """
  end

  def handle_event("validate", params, socket) do
    form_params = Map.get(params, "form", %{})
    form = AshPhoenix.Form.validate(socket.assigns.form, form_params)
    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("submit", params, socket) do
    form_params = Map.get(params, "form", %{})

    case AshPhoenix.Form.submit(socket.assigns.form, params: form_params) do
      {:ok, form_struct} ->
        params = %{
          account_id: socket.assigns.account_id,
          date_of_birth: form_struct.date_of_birth
        }

        {:ok, _command} = MyGroupCollectRegister.Commands.ConfirmAdult.dispatch_command(params)

        send(self(), :confirm_adult_form_submitted)
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
