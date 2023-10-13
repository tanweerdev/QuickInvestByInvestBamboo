import Config

# Configure your database
config :quick_invest, QuickInvest.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "operational_task_dev",
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :quick_invest, QuickInvestWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "HOHejylKdef5H1c+VWaxU0ezZxl9yrZHeDmHoYy/ZJ8H4OavbVtDj1Ytj3C7osJ9",
  watchers: []

# Enable dev routes for dashboard and mailbox
config :quick_invest, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
