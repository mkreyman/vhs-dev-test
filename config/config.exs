# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :vhs_dev_test, VhsDevTestWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "HF6fVqZgwoikjgVz58GsIR8lTzYeantP435l5Qiarh0xZBU3mecFZc00IjnKy5gk",
  render_errors: [view: VhsDevTestWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: VhsDevTest.PubSub,
  live_view: [signing_salt: "HtsTDwmy"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Blocknative configuration
config :vhs_dev_test, :blocknative,
  api: "https://api.blocknative.com",
  redirect_uri: "http://localhost:4000/blocknative-webhook",
  api_key: System.get_env("BLOCKNATIVE_API_KEY"),
  eth_address: System.get_env("ETH_ADDRESS")

# Slack configuration
config :vhs_dev_test, :slack, webhook: System.get_env("SLACK_WEBHOOK_URL")

config :vhs_dev_test, :http_client, HTTPoison

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
