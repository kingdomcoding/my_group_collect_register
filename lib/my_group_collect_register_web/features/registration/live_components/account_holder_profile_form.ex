defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.AccountHolderProfileForm do
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
                      Account holder profile
                  </h1>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      You're not being asked to register for this trip as a passanger.
                  </p>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      You may add yourself as a passanger later in the process if you'd like.
                  </p>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.input field={@form[:first_name]} label="First name"/>
                      <.input field={@form[:last_name]} label="Last name"/>
                      <.input field={@form[:phone_number]} label="Phone number"/>

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
          first_name: form_struct.first_name,
          last_name: form_struct.last_name,
          phone_number: form_struct.phone_number,
        }

        {:ok, _command} = MyGroupCollectRegister.Commands.SubmitAccountHolderProfile.dispatch_command(params)

        send(self(), :account_holder_profile_form_submitted)
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
