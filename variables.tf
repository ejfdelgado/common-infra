variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ejfexperiments"
}

variable "firebase_project_id" {
  description = "Firebase Project Id"
  type        = string
  default     = "ejfexperiments"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "pro"
}

variable "location" {
  description = "Location"
  type        = string
  default     = "us-central"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "us-central1-c"
}

variable "zonegpu" {
  description = "Zone"
  type        = string
  default     = "us-central1-a"
}

variable "email" {
  description = "Email"
  type        = string
  default     = "edgar.jose.fernando.delgado@gmail.com"
}

variable "stack_id" {
  description = "Nombre del ambiente"
  type        = string
  default     = "pro"
}

variable "layer" {
  description = "Nombre del proyecto"
  type        = string
  default     = "test"
}

variable "common_backend_image" {
  description = "Node Server Image"
  type        = string
  default     = ""
}
