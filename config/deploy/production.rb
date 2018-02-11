# frozen_string_literal: true

server "diogenes.se.uni-hannover.de", user: "plre1", roles: %w{app db web}


set :default_env,
    "PASSENGER_INSTANCE_REGISTRY_DIR" => "/var/run/passenger-instreg"
