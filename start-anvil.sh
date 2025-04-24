#!/bin/bash
set -e

# Check if state file exists and is not empty
if [ -s /app/data/anvil-state.json ]; then
  echo "Starting Anvil with existing state from file..."
  # Start anvil with the state file
  anvil --host 0.0.0.0 --steps-tracing --load-state /app/data/anvil-state.json --dump-state /app/data/anvil-state.json
else
  echo "State file does not exist or is empty. Starting Anvil with fresh state..."
  # Start anvil without state file, but still dump state when exiting
  anvil --host 0.0.0.0 --steps-tracing --dump-state /app/data/anvil-state.json
fi 