# common-infra.

```

export GOOGLE_APPLICATION_CREDENTIALS=/run/media/ubuntu/54cdff7d-b0af-4019-9109-017d1af36f70/home/ejfdelgado/desarrollo/common-secrets/ejfexperiments-e9b4de341343.json

terraform init
terraform plan
terraform workspace new pro
terraform workspace new stg
```

Cada vez que se quiera aplicar la infraestructura para ambiente de calidad usar:

```
terraform workspace select stg && terraform apply -var-file="env.stg.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```

y para ambiente de producción usar, ONLY use pro!

```
terraform workspace select pro && terraform apply -var-file="env.pro.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```

```
terraform workspace select pro && terraform import google_storage_bucket.static_site_old pro-ejflab-assets
```

```
terraform workspace select stg && terraform import google_storage_bucket.static_site_old stg-ejflab-assets
```

```
terraform import google_firestore_database.default "projects/ejfexperiments/databases/(default)"
```

```
terraform init \
  -migrate-state \
  -backend-config="bucket=pro-ejflab-terraform"
```