defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AddressForm do
  use MyGroupCollectRegisterWeb, :live_component

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
                      Where do you live?
                  </h1>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      We need this information for compliance reason or in case we ever need to send you a check.
                  </p>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.input field={@form[:street]} type="textarea" label="Street"/>
                      <.input field={@form[:city]} label="City"/>
                      <!-- TODO: Give dynamic options -->
                      <.input field={@form[:state]} label="State" type="select" options={["Florida", "Georgia"]} />

                      <.input field={@form[:zip]} label="Zip"/>

                      <!-- TODO: Give dynamic options -->
                      <.input field={@form[:country]} label="Country" type="select" options={["United States", "Canada"]} />
                      <:actions>
                        <.button>Save</.button>
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
          street: form_struct.street,
          city: form_struct.city,
          state: form_struct.state,
          zip: form_struct.zip,
          country: form_struct.country,
        }

        {:ok, _command} = MyGroupCollectRegister.Commands.SubmitAddress.dispatch_command(params)

        send(self(), :address_form_submitted)
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
