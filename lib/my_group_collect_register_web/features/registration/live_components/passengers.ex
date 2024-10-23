defmodule MyGroupCollectRegisterWeb.Features.Registration.LiveComponents.Passengers do
  use MyGroupCollectRegisterWeb, :live_component

  def update(%{account_id: account_id, trip_id: trip_id} = assigns, socket) do
    {:ok, passengers} = MyGroupCollectRegister.ReadModels.Passengers.get_by_account_and_trip(account_id, trip_id)

    socket =
      socket
      |> assign(account_id: account_id)
      |> assign(trip_id: trip_id)
      |> assign(passengers: passengers)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <section class="bg-gray-50 dark:bg-gray-900 py-3 sm:py-5 antialiased">
        <div class="mx-auto max-w-screen-2xl px-4 lg:px-12">
            <div class="bg-white dark:bg-gray-800 relative shadow-md sm:rounded-lg">
                <div class="py-6 px-4 space-y-4 md:space-y-6 sm:py-8" sm:px-4>
                  <h1 class="text-xl font-bold leading-tight tracking-tight text-gray-900 md:text-2xl dark:text-white">
                    Passengers
                  </h1>
                  <p class="text-sm font-light text-gray-500 dark:text-gray-400">
                      These are the passengers who are travelling.
                  </p>
                </div>
                <div class="overflow-x-auto mx-4 space-y-4">
                    <%= for passenger <- @passengers do %>
                      <div class="w-full flex flex-col md:flex-row md:items-center relative p-6 md:space-x-6 hover:bg-gray-50 dark:hover:bg-gray-600 bg-white border border-gray-200 rounded-lg shadow dark:bg-gray-700 dark:border-gray-600">
                          <div class="flex flex-col md:justify-between">
                              <div class="grid w-full gap-2">
                                  <div class="col-span-1">
                                      <h6 class="text-sm font-normal text-gray-500 dark:text-gray-400">Full Legal Name</h6>
                                      <p class="text-sm font-semibold text-gray-900 dark:text-white"><%= passenger.full_legal_name %></p>
                                  </div>
                                  <div class="col-span-1">
                                      <h6 class="text-sm font-normal text-gray-500 dark:text-gray-400">Age</h6>
                                      <p class="text-sm font-semibold text-gray-900 dark:text-white"><%= passenger.age_class %></p>
                                  </div>
                              </div>
                          </div>
                          <div class="absolute top-3 right-3">
                              <button phx-click="edit-passenger"  type="button" class="inline-flex items-center p-1.5 text-sm font-medium text-center text-gray-500 hover:text-gray-800 hover:bg-gray-200 dark:hover:bg-gray-500 rounded-lg focus:outline-none dark:text-gray-400 dark:hover:text-gray-100">
                                  <svg class="w-5 h-5" aria-hidden="true" fill="currentColor" viewbox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                                      <path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" />
                                  </svg>
                                  <span class="pl-1">Edit</span>
                              </button>
                          </div>
                      </div>
                    <% end %>
                    <div class="flex flex-col items-center justify-center space-y-3 py-5">
                        <div class="inline-flex items-stretch -space-x-px gap-4">
                            <button phx-click="add-passenger" class="flex text-sm items-center justify-center h-full py-1.5 px-3 ml-0 text-gray-500 bg-white rounded-lg border border-gray-300 hover:bg-primary-100 hover:text-primary-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">
                              Add another passenger
                            </button>
                            <button phx-click="next" phx-target={@myself} class="bg-primary flex text-sm items-center justify-center h-full py-1.5 px-3 ml-0 text-white rounded-lg border border-gray-300 hover:bg-primary-100 hover:text-primary-700 dark:bg-gray-800 dark:border-gray-700 dark:text-gray-400 dark:hover:bg-gray-700 dark:hover:text-white">
                              Next
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    """
  end

  def handle_event("next", _unsigned_params, socket) do
    send(self(), :passenger_details_verified)
    {:noreply, socket}
  end
end
