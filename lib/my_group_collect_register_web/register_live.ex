defmodule MyGroupCollectRegisterWeb.RegisterLive do
  use MyGroupCollectRegisterWeb, :live_view

  alias __MODULE__.Page1Form

  def render(%{live_action: :page_1} = assigns) do
    ~H"""
    <.live_component module={__MODULE__.Page1Form} id="page_1" />
    """
  end
end
