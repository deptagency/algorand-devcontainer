# deptagency/algorand-devcontainer

Algorand devcontainer including:

- [AlgoKit](https://developer.algorand.org/algokit/) (no need to start/stop localnet)
- [Algod](https://developer.algorand.org/docs/rest-apis/algod/) setup as a private node
- [Indexer](https://developer.algorand.org/docs/rest-apis/indexer/) and Postgres DB
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
