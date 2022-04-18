variable "region" {
  default     = "eu-central-1"
  description = "AWS region"
}

variable "cluster_name" {
  default = "terraform-eks-demo"
}

variable "map_accounts" {
  description = "Additional AWS account numbers to add to the aws-auth configmap."
  type        = list(string)

  default = [
    "<account_id>",
  ]
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::<account_id>:user/terraform-user"
      username = "terraform-user"
      groups   = ["system:masters"]
    },
  ]
}
