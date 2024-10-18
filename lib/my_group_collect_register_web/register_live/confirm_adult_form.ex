defmodule MyGroupCollectRegisterWeb.RegisterLive.ConfirmAdultForm do
  use MyGroupCollectRegisterWeb, :live_component

  alias MyGroupCollectRegisterWeb.RegisterLive.ConfirmAdultFormFields

  def update(_assigns, socket) do
    form = AshPhoenix.Form.for_create(ConfirmAdultFormFields, :submit, domain: MyGroupCollectRegisterWeb.RegisterDomain) |> to_form()

    {:ok, assign(socket, :form, form)}
  end

  def render(assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
          <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
              <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                  <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                      Confirm you're an adult
                  </h1>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      You must be 18 or older to use this system
                  </p>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.input field={@form[:date_of_birth]} label="YOUR Date of birth" type="date"/>

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
        # TODO: Dispatch command
        # {:ok, %{account_id: account_id}} = MyGroupCollectRegister.Commands.CreateAnAccount.dispatch_command(form_params)

        send(self(), :confirm_adult_form_submitted)
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
