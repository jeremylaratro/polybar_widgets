# Public IP

Show your public IP address with caching.

## Features

- Displays public IP
- 5-minute cache to avoid excessive API calls
- Click to open ipleak.net for details
- Falls back to cached IP on network errors

## Configuration

```bash
export PUBLIC_IP_CACHE_AGE=600  # cache for 10 minutes
```
