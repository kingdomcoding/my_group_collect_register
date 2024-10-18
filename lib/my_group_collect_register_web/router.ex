defmodule MyGroupCollectRegisterWeb.Router do
  use MyGroupCollectRegisterWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyGroupCollectRegisterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyGroupCollectRegisterWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/register", RegisterLive, :create_an_account
    live "/register/check-email", RegisterLive, :check_email
    live "/register/confirm-email/:account_id", RegisterLive, :confirm_email
    live "/register/:registration_id/confirm-adult", RegisterLive, :confirm_adult
    live "/register/:registration_id/account-holder-profile", RegisterLive, :account_holder_profile
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyGroupCollectRegisterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_group_collect_register, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyGroupCollectRegisterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
