# deptagency/algorand-devcontainer

Algorand devcontainer including:

- AlgoKit
- Algorand private node
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

The above should work with [Dappflow](https://app.dappflow.org)'s Sandbox config.

## GitHub container registry

```sh
docker pull ghcr.io/deptagency/algorand-devcontainer
```

## TODO

- Even better shell (maybe p10k)
- Setup basic Node.js package.json?
- Add some script utilities
- Customize algod/indexer settings further
