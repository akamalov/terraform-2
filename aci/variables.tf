variable "vsts-account" {
  default = "eneros"
}

variable "vsts-token" {
  default = ""
}

variable "vsts-agent" {
  default = "ACI-Agent"
}

variable "vsts-pool" {
  default = "ACI-Pool"
}

variable "image" {
  description = "docker image name for the agent"
}
