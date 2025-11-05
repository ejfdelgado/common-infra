# common-infra

```
export GOOGLE_APPLICATION_CREDENTIALS=/home/ejfdelgado/desarrollo/ejflab-playground/credentials/ejfexperiments-c2ef2a890ca5.json
terraform init
terraform plan
terraform workspace new pro
terraform workspace new stg
```

Cada vez que se quiera aplicar la infraestructura para ambiente de calidad usar:

```
terraform workspace select stg && terraform apply -var-file="env.stg.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```

y para ambiente de producción usar:

```
terraform workspace select pro && terraform apply -var-file="env.pro.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```

```
terraform workspace select pro && terraform import google_storage_bucket.static_site_old pro-ejflab-assets
```

```
terraform workspace select stg && terraform import google_storage_bucket.static_site_old stg-ejflab-assets
```
