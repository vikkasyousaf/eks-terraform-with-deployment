### Solution
I have choose to create aws eks as it easy to operate and manage the cluster and worker nodes. For the given challenge i have create eks cluster using terraform version `1.1`.
Created a backend pipeline to keep the terraform `state` file in the s3 bucket.

#### Why EKS

#### Self-managed:
You bring your own servers and have more control of the server. You have to manage it yourself though. So people also call this unmanaged.
#### Managed Node Groups:
AWS manages the servers for you. You just have to specify some configurations of server instance types.
#### AWS Fargate:
AWS manages even more of the server for you. You don't even have to think about instance types. Just tell EKS how much RAM and CPU you need and that's it.

### EKS Cluster Setup
For the give challenge i have create the following Resources:
* VPC with two private subnets as it is more secure to run the application in private nodes.
* Internet gateways so that the application are able to run on http and https
* Create respective routing table and its association
* Created eks cluster using the module `terraform-aws-modules/eks/aws` with cluster version `1.21`
* Created kms Encryption key to encrypt the secrets in the cluster(for now we dont have any secrets)
* Used `eks_managed_node_groups` so that the node are added to the cluster upon creation of the cluster.
* Added tags to the respective Resources

## How to rollout
For this challenge we are using terraform version `1.1`.

### Testing Instructions
```
terraform init
terraform plan
```

### How to roll out
```
terraform apply
```

Once the cluster is rolled out, we have to also update the kube_config file so that we have the correct configuration/certifiacte in order to access the clusters
```
aws eks --region eu-central-1 update-kubeconfig --name my-eks
```
To verify if you are able to access the cluster, switch to the context
```
kubectl config use-context arn:aws:eks:eu-central-1:<account_id>:cluster/my-eks
```
```
kubectl get nodes
```

### Thing to Improve
This is a very basic eks cluster. In order to make it production ready cluster, we will need to make the following adjustments:
* Create a natgateway for the communication between nodes
* Create and add ssh key to the nodes to access the node for maintanace and troubleshooting
* Creating an IAM OIDC identity provider for the cluster, to create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam
* Creating role and cluster role binding for the CI/CD
* Creating role and cluster role for user managment, creating separate role for engineer and Devops/SRE
* Provision cluster using ansible or similar tools
* Add know gpg key to the respository so that only known user could rollout changes to the cluster
* Creating a CI/CD pipeline to rollout deployment to the cluster.
* Create a make file which include lint check, code formatting and so on
* Should have dedicated IAM User or role to run terraform apply
* Integrate atlantis to the respository so that the terraform plan and apply are automated.
* Create a pipeline to keep the stat file in the s3 bucket(encrypted)
* Configure dynamodb for the version control of terraform state

### Monitoring
* The module allow us to enable logging so that the logs are available on cloudwatch.
* Beside this there a lot of logs shipper which could be use to ship logs e.g using logstash/filebeat to ship logs to elasticsearch cluster.
* For metric it also depend on to tool which tool we will use to monitoring the cluster. e.g cloudwatch, promethous, elasticsearch etc.
