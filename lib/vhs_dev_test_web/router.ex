defmodule VhsDevTestWeb.Router do
  use VhsDevTestWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    # plug VhsDevTestWeb.ReadHeader
  end

  scope "/api", VhsDevTestWeb do
    pipe_through :api
  end

  scope "/blocknative-webhook" do
    pipe_through :api
    post "/", VhsDevTestWeb.BlocknativeController, :webhooks
  end

  scope "/transaction" do
    pipe_through :api
    get "/", VhsDevTestWeb.TransactionController, :request_status
  end

  scope "/transactions" do
    pipe_through :api
    get "/", VhsDevTestWeb.TransactionController, :watched_transactions
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: VhsDevTestWeb.Telemetry
    end
  end
end
