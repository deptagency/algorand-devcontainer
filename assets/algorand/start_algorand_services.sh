#!/usr/bin/env zsh

set -Eeuo pipefail

echo "Configuring..."

# Set algod and kmd token to 64 a's
token="aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
echo $token > $ALGORAND_DATA/algod.token
echo $token > $ALGORAND_DATA/kmd-v0.5/kmd.token

# Setup with our own configuration
cp ~/config.json $ALGORAND_DATA/
cp ~/kmd_config.json $ALGORAND_DATA/kmd-v0.5/

# Start Algod
echo "Starting algod..."
goal network start -r $ALGORAND_PRIVNET || goal node start

# Hold off for a bit to let the network get going
echo "Waiting..."
sleep 5s

# Start Kmd
echo "Starting kmd..."
goal kmd start

# Reset the database in case the private network was recreated
echo "Clearing indexer database..."
psql -c "DROP TABLE IF EXISTS account, account_app, account_asset, app, app_box, asset, block_header, metastate, txn, txn_participation CASCADE"

# Start the indexer
echo "Starting indexer"
nohup algorand-indexer daemon --allow-migration --server "0.0.0.0:8980" --postgres "host=$PGHOST user=$PGUSER password=$PGPASSWORD dbname=$PGDATABASE sslmode=disable" &> indexer.log &
