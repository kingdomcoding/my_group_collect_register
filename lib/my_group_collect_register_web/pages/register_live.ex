defmodule MyGroupCollectRegisterWeb.Pages.RegisterLive do
  use MyGroupCollectRegisterWeb, :live_view

  alias MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.{
    CreateAnAccountForm,
    ConfirmAdultForm,
    AccountHolderProfileForm,
  }

  def handle_params(%{"account_id" => account_id} = _unsigned_params, _uri, %{assigns: %{live_action: :confirm_email}} = socket) do
    {:ok, _command} = MyGroupCollectRegister.Commands.ConfirmEmail.dispatch_command(%{account_id: account_id})

    {:noreply, push_patch(socket, to: ~p"/register/#{account_id}/confirm-adult")}
  end

  def handle_params(%{"account_id" => account_id} = _unsigned_params, _uri, socket) do
    {:noreply, assign(socket, :account_id, account_id)}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(%{live_action: :create_an_account} = assigns) do
    ~H"""
    <.live_component module={CreateAnAccountForm} id="create_an_account_form" />
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
    <.live_component module={ConfirmAdultForm} id="confirm_adult_form" account_id={@account_id} />
    """
  end

  def render(%{live_action: :account_holder_profile} = assigns) do
    ~H"""
    <.live_component module={AccountHolderProfileForm} id="account_holder_profile_form" account_id={@account_id} />
    """
  end

  def render(%{live_action: :where_do_you_live} = assigns) do
    # <.live_component module={AccountHolderProfileForm} id="account_holder_profile_form" account_id={@account_id} />
    ~H"""
    <h1>Where do you live?</h1>
    """
  end

  def handle_info({:create_an_account_form_submitted, account_id}, socket) do
    socket =
      socket
      |> assign(:account_id, account_id)
      |> push_patch(to: ~p"/register/check-email")

    {:noreply, socket}
  end

  def handle_info(:confirm_adult_form_submitted, socket) do
    socket =
      socket
      |> push_patch(to: ~p"/register/#{socket.assigns.account_id}/account-holder-profile")

    {:noreply, socket}
  end

  def handle_info(:account_holder_profile_form_submitted, socket) do
    socket =
      socket
      |> push_patch(to: ~p"/register/#{socket.assigns.account_id}/where-do-you-live")

    {:noreply, socket}
  end
end