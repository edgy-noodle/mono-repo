# cloudflare-tunnel

Connect/manage Cloudflare (Argo) tunnels.

## Usage

### Prerequisites

- Cloudflare account and domain
- `cloudflared` CLI (see [links](#useful-links))

> NOTE: This chart supports both remotely-managed, as well as locally-managed tunnels.  
> Choose your flavor based on whether you want to manage it in the UI, or in your helm release config.

### Values

#### Cloudflare

| Property                                 | Default | Type      | Description                                                                                                                                                                                                                                                                        |
|------------------------------------------|---------|-----------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `cloudflare.remote`                      | `false` | `Boolean` | If using a remote tunnel, change to `true`.                                                                                                                                                                                                                                        |
| `cloudflare.remote_vars.token`           | `""`    | `String`  | Remote tunnel token value.                                                                                                                                                                                                                                                         |
| `cloudflare.remote_vars.tokenSecretName` | `null`  | `String`  | Name of a pre-existing secret to use instead of generating a new one.<br/>The secret must contain a key `tunnelToken`. Overrides `token` variable.                                                                                                                                 |
| `cloudflare.local_vars.tunnelName`       | `""`    | `String`  | Name of your tunnel.                                                                                                                                                                                                                                                               |
| `cloudflare.local_vars.accountTag`       | `""`    | `String`  | Cloudflare account tag/ID (see [credentials file](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/tunnel-useful-terms/#credentials-file)).                                                                                               |
| `cloudflare.local_vars.tunnelId`         | `""`    | `String`  | ID of your tunnel (see [credentials file](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/tunnel-useful-terms/#credentials-file)).                                                                                                       |
| `cloudflare.local_vars.tunnelSecret`     | `""`    | `String`  | Your tunnel secret (see [credentials file](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/tunnel-useful-terms/#credentials-file)).                                                                                                      |
| `cloudflare.local_vars.tunnelSecretName` | `""`    | `String`  | Name of a pre-existing secret to use instead of generating a new one.<br/>The secret must contain keys: `AccountTag`, `TunnelID`, `TunnelSecret`. Overrides credentials file variables.                                                                                            |
| `cloudflare.local_vars.warp`             | `false` | `Boolean` | If using WARP, change to `true`.                                                                                                                                                                                                                                                   |
| `cloudflare.local_vars.ingress`          | `[]`    | `Array`   | Rules for proxying traffic from Cloudflare endpoint to cluster services (see [public hostnames config](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/configure-tunnels/local-management/configuration-file/#file-structure-for-public-hostnames)). |

### Local tunnel

1. Create the tunnel as described in the docs (see [links](#useful-links)).
2. Grab tunnel token displayed in the UI.
3. Create a YAML file with your values.

### Remote tunnel

1. Create the tunnel as described in the docs (see [links](#useful-links)).
2. Grab tunnel details from credentials file (see this [directory](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/tunnel-useful-terms/#default-cloudflared-directory)).
3. Create a YAML file with your values.

### Installation

```shell
helm repo add <alias> https://edgy-noodle.github.io/helm-charts
helm install -f your_values.yaml <alias>/cloudflare-tunnel
```

## Useful links
- [Cloudflare sign up](https://dash.cloudflare.com/sign-up)
- Cloudflared
  - [Download](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/)
  - [Create tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/)
