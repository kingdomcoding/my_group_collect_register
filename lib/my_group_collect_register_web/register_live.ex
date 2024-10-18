defmodule MyGroupCollectRegisterWeb.RegisterLive do
  use MyGroupCollectRegisterWeb, :live_view

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, socket}
  end

  def render(%{live_action: :page_1} = assigns) do
    ~H"""
    <.live_component module={__MODULE__.Page1Form} id="page_1" />
    """
  end

  def render(%{live_action: :check_email} = assigns) do
    ~H"""
    <p>Check your email</p>
    """
  end

  def handle_info(:form_submitted, socket) do
    case socket.assigns.live_action do
      :page_1 ->
        {:noreply, push_patch(socket, to: ~p"/register/check-email")}
    end
  end
end
