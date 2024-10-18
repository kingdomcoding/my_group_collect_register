defmodule MyGroupCollectRegisterWeb.RegisterLive do
  use MyGroupCollectRegisterWeb, :live_view

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
    <p>Check your email</p>
    """
  end

  def handle_info(:form_submitted, socket) do
    case socket.assigns.live_action do
      :create_an_account ->
        {:noreply, push_patch(socket, to: ~p"/register/check-email")}
    end
  end
end
