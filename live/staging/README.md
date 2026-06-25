# live/staging

Staging environment. Start by copying the structure of [`../dev`](../dev):

```bash
cp ../dev/{versions.tf,providers.tf,variables.tf,main.tf,outputs.tf} .
cp ../dev/backend.tf .   # then change key/prefix to live/staging
cp ../dev/terraform.tfvars.example .
```

Then bump sizing for staging (e.g. larger node counts, `spot = false`,
disable preemptible/spot where you want stability) and set the backend `key`
(S3) or `prefix` (GCS) to `live/staging`.
