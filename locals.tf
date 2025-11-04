locals {
  timestamp       = formatdate("YYMMDDhhmmss", timestamp())
    secrets       = jsondecode(file("../common-secrets/pro.json"))
}
