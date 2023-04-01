# deptagency/algorand-devcontainer

Algorand devcontainer including:

- [AlgoKit](https://developer.algorand.org/algokit/) and all prerequisites:
  - Python 3.10+ (as required by PyTEAL)
  - Node.js LTS (plus yarn and pnpm)
  - Docker CLI (to allow `algokit localnet start/stop`)
  - Poetry
  - pipx

Thanks to AlgoKit you can use [Dappflow](https://app.dappflow.org) to test your smart contract.

> IMPORTANT! After you've setup your project with `algokit init` you will need to replace any `http://localhost` references with `http://host.docker.internal` to allow `python -m smart_contracts` to build and deploy successfully.

## Usage

Check the [example](/example/) directory for how to setup your devcontainer.

## GitHub container registry

```sh
docker pull ghcr.io/deptagency/algorand-devcontainer
```

## TODO

- Even better shell (maybe p10k)
- Setup basic Node.js package.json?
- Add some script utilities
