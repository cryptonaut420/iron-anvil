#!/bin/bash
set -e

# Check if transaction hash was provided
if [ -z "$1" ]; then
  echo "Error: Transaction hash required"
  echo "Usage: ./trace-tx.sh <TRANSACTION_HASH>"
  exit 1
fi

TX_HASH=$1
RPC_URL="${2:-http://localhost:8545}"

echo "Fetching transaction trace for: $TX_HASH"
echo "Using RPC URL: $RPC_URL"
echo "----------------------------------------------"

# Get basic transaction info
echo "Transaction Details:"
cast tx $TX_HASH --rpc-url $RPC_URL
echo ""

# Get transaction receipt (contains events/logs) but exclude the verbose logs data
echo "Transaction Receipt Summary:"
cast receipt $TX_HASH --rpc-url $RPC_URL | grep -v "logs " | grep -v "logsBloom"
echo ""

# Get function calls and events in a clear format
echo "Function Calls and Events:"
cast run $TX_HASH --rpc-url $RPC_URL | grep -E "Traces:|0x|emit|call|return" | grep -v "depth:" | grep -v "OPCODE:" | grep -v "Stack:" | grep -v "Data size:" | grep -v "Memory:"

# Add coloring to the events
echo ""
echo "Highlighted Events:"
cast run $TX_HASH --rpc-url $RPC_URL | grep -E "emit" --color=always

echo ""
echo "----------------------------------------------"
echo "Trace completed" 