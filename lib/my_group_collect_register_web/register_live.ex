defmodule MyGroupCollectRegisterWeb.RegisterLive do
  use MyGroupCollectRegisterWeb, :live_view
  # account_id
  def handle_params(%{"account_id" => account_id} = _unsigned_params, _uri, %{assigns: %{live_action: :confirm_email}} = socket) do
    # TODO: Dispatch command
    registration_id = Ash.UUID.generate()

    {:noreply, push_patch(socket, to: ~p"/register/#{registration_id}/confirm-adult")}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(%{live_action: :create_an_account} = assigns) do
    ~H"""
    <.live_component module={__MODULE__.CreateAnAccountForm} id="create_an_account_form" />
    """
  end

  def render(%{live_action: :check_email} = assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900">
      <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
          <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-800 dark:border-gray-700">
              <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
                  <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                      Confirm email address
                  </h1>
                  <p class="text-sm font-light">
                      We just sent you an email with the subject Confirm your email. Once you find it, click the Confirm button.
                  </p>
                  <p class="text-sm font-light">
                      Well, not really :)
                  </p>
                  <p class="text-sm">
                      Just <a href={~p"/register/confirm-email/#{@account_id}"} class="font-medium text-primary-600 hover:underline dark:text-primary-500">click to confirm your email addrees</a>
                  </p>
              </div>
          </div>
      </div>
    </section>
    """
  end

  def render(%{live_action: :confirm_adult} = assigns) do
    ~H"""
    <h1>Confirm adult</h1>
    """
  end

  def handle_info({:create_an_account_form_submitted, account_id}, socket) do
    socket =
      socket
      |> assign(:account_id, account_id)
      |> push_patch(to: ~p"/register/check-email")

    {:noreply, socket}
  end
end
