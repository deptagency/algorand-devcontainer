# smonn/algo-devkit

Algorand dev container

- Algorand private node (with CLI tools goal, tealdbg, etc)
- Indexer and Postgres DB
- Python 3.10+ (as required by PyTEAL)
- Node.js LTS (plus yarn and pnpm)

For now, the Dockerfile includes a lot and will take a few minutes at least to build. The plan is to turn it into a pre-built Docker image for better reusability.

Algod, Kmd, and Indexer settings are matching the Algorand Sandbox setup:

- `algod`:
  - address: `http://localhost:4001`
  - token: `aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`
- `kmd`:
  - address: `http://localhost:4002`
  - token: `aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`
- `indexer`:
  - address: `http://localhost:8980`

## Docker repository

https://hub.docker.com/r/smonn/algo-devkit

## TODO

- Even better shell (maybe p10k)
- Setup poetry for managing python dependencies?
- Setup basic Node.js package.json?
- Add some script utilities
- Customize algod/indexer settings further
