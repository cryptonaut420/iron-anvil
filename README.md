# Iron Anvil - Persistent Anvil Server

This is a Docker-based setup for running a persistent Anvil server for Ethereum development.

## Features

- Runs Anvil on a persistent Docker container
- State is preserved between container restarts and system reboots
- Automatic state saving every hour
- Automatic process monitoring and restart with Supervisord
- Exposed on port 8545 with host 0.0.0.0 for full network access

## Getting Started

### Prerequisites

- Docker and Docker Compose installed on your system

### Deployment

1. Run the deployment script:

```bash
./docker-deploy
```

This will build and start the Docker container.

2. After deployment, your Anvil RPC endpoint will be available at:

```
http://localhost:8545
```

### Access Container for Debugging

If you need to access the container shell for debugging:

```bash
./docker-access
```

### Manual State Operations

The state is automatically saved every hour via cron, but you can also trigger a state save manually by accessing the container and running:

```bash
/app/save-state.sh
```

### RPC Methods

You can interact with the Anvil server using standard Ethereum JSON-RPC methods, as well as Anvil-specific methods:

- `anvil_dumpState`: Save the current state to a file
- `anvil_loadState`: Load state from a file

Example (from host machine):

```bash
# Save state manually
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"anvil_dumpState","params":["/app/data/anvil-state.json"],"id":1}' http://localhost:8545
```

## Notes

- State files are stored in the `./data` directory which is mounted to `/app/data` in the container
- The Anvil server is configured to automatically load state on startup and dump state on shutdown
- If the server crashes, Supervisord will automatically restart it with the last saved state 