defmodule MyGroupCollectRegisterWeb.Features.Registration.Components do
  use MyGroupCollectRegisterWeb, :html

  attr :field, Phoenix.HTML.FormField, required: true
  attr :label, :string, default: ""
  attr :options, :list, required: true

  def radio_group(assigns) do
    assigns = assign(assigns, :errors, Enum.map(assigns.field.errors, &translate_error(&1)))
    
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
end
