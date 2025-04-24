#!/bin/bash
set -e

echo "Saving Anvil state at $(date)"

# Use curl to make an RPC call to save the state
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"anvil_dumpState","params":["/app/data/anvil-state.json"],"id":1}' http://localhost:8545

echo "State saved successfully" 