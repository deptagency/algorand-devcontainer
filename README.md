# smonn/algo-devkit

Algorand devcontainer

- Algorand private node (with CLI tools goal, tealdbg, etc)
- Indexer and Postgres DB
- Python 3.10+ (as required by PyTEAL)
- Node.js LTS (plus yarn and pnpm)

Algod, Kmd, and Indexer settings are matching the Algorand Sandbox setup:

- `algod`:
  - address: `http://localhost:4001`
  - token: `aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`
- `kmd`:
  - address: `http://localhost:4002`
  - token: `aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa`
- `indexer`:
  - address: `http://localhost:8980`

## GitHub container registry

```sh
docker pull ghcr.io/smonn/algo-devkit
```

## TODO

- Even better shell (maybe p10k)
- Setup poetry for managing python dependencies?
- Setup basic Node.js package.json?
- Add some script utilities
- Customize algod/indexer settings further
