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
    <p><%= @account_id %></p>
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
