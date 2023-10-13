# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :quick_invest,
  ecto_repos: [QuickInvest.Repo]

# Configures the endpoint
config :quick_invest, QuickInvestWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: QuickInvestWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: QuickInvest.PubSub,
  live_view: [signing_salt: "xt/zvOjc"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :quick_invest, QuickInvest.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :quick_invest, :allowed_categories, ~w(technology real_estate finance)a

config :quick_invest, QuickInvest.Events.ConsumerSupervisor, consumer_count: 10

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
