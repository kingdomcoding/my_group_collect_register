# Setup database
mix ecto.setup
mix event_store.setup

# Make server file executable
chmod a+x _build/prod/rel/my_group_collect_register/bin/server

# Start server
_build/prod/rel/my_group_collect_register/bin/server
