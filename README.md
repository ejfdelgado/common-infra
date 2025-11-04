# common-infra

export GOOGLE_APPLICATION_CREDENTIALS=/home/ejfdelgado/desarrollo/ejflab-playground/credentials/ejfexperiments-c2ef2a890ca5.json
terraform init
terraform plan
terraform state rm
terraform apply && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit