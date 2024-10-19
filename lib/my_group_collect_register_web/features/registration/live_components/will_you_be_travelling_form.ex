defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.WillYouBeTravellingForm do
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
                      Will you be travelling?
                  </h1>
                  <.simple_form for={@form} class="space-y-4 md:space-y-6" phx-change="validate" phx-submit="submit" phx-target={@myself}>
                      <.radio_group field={@form[:will_you_be_travelling?]} options={[{"Yes, I will be travelling", "yes"}, {"No, I'm registering someone else", "no"}]} />


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

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, default: ""
  attr :options, :list, required: true

  def radio_group(assigns) do
    # TODO: Translate errors
    errors = if Phoenix.Component.used_input?(assigns.field), do: assigns.field.errors, else: []

    assigns = assign(assigns, :errors, Enum.map(errors, &translate_error(&1)))
    ~H"""
    <div>
        <label class="block mb-2 text-sm font-medium text-gray-900 dark:text-white">
          <%= @label %>
        </label>
        <div class="space-y-2">
          <%= for {label, value} <- @options do %>
            <div class="flex items-center">
                <.radio_button field={@field} label={label} value={value} checked={to_string(@field.value) == value} />
            </div>
          <% end %>
        </div>
        <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, required: true
  attr :value, :string, required: true
  attr :checked, :boolean, default: false

  def radio_button(assigns) do
    ~H"""
    <div class="flex items-center pl-3 gap-2 lg:pl-0">
        <input id={"#{@field.id}_#{@value}"} type="radio" value={@value} checked={@checked} name={@field.name} class="w-4 h-4 lg:mx-auto text-blue-600 bg-gray-100 border-gray-300 focus:ring-blue-500 dark:focus:ring-blue-600 dark:ring-offset-gray-700 dark:focus:ring-offset-gray-700 focus:ring-2 dark:bg-gray-600 dark:border-gray-500">
        <label for={"#{@field.id}_#{@value}"} class="text-sm font-medium text-gray-900 dark:text-gray-300"><%= @label %></label>
    </div>
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
        # params = %{
        #   account_id: socket.assigns.account_id,
        #   street: form_struct.street,
        #   city: form_struct.city,
        #   state: form_struct.state,
        #   zip: form_struct.zip,
        #   country: form_struct.country,
        # }

        # {:ok, _command} = MyGroupCollectRegister.Commands.SubmitAddress.dispatch_command(params)

        send(self(), {:will_you_be_travelling_form_submitted, form_struct.will_you_be_travelling?})
        {:noreply, socket}
      {:error, form_with_error} ->
        {:noreply, assign(socket, :form, form_with_error)}
    end
  end
end
