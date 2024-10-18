defmodule MyGroupCollectRegisterWeb.RegisterLive.Page1Form do
  use MyGroupCollectRegisterWeb, :live_component

  alias MyGroupCollectRegisterWeb.RegisterLive.Page1FormFields

  def update(_assigns, socket) do
    form = AshPhoenix.Form.for_create(Page1FormFields, :submit, domain: MyGroupCollectRegisterWeb.RegisterDomain) |> to_form()

    {:ok, assign(socket, :form, form)}
  end

  def render(assigns) do
    # TODO: Add url linking
    # <a class="font-medium text-primary-600 hover:underline dark:text-primary-500" href="#">Terms of Service</a>
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
          <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
              <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                  <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                      Create an account
                  </h1>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      Already have an account? <a href="#" class="font-medium text-primary-600 hover:underline dark:text-primary-500">Login here</a>
                  </p>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.input field={@form[:email]} label="Email"/>
                      <.input field={@form[:password]} label="Password" type="password"/>
                      <.input field={@form[:agree_to_terms?]} label="I agree to the Terms of Service and Privacy Policy" type="checkbox"/>

                      <:actions>
                        <.button>Create account</.button>
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
      {:ok, _form_struct} ->
        # TODO: Navigate to next page
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
