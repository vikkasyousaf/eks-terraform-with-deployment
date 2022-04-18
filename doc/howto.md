### Solution
I have choose to create aws eks as it easy to operate and manage the cluster and worker nodes. AWS manages the servers for us. and we just have to specify some configurations of server instance types. For the given challenge i have create eks cluster using terraform version `1.1`.


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
* For this demo i have used a smaller instances as we will have to run only a single deployment.
* I have create a `eks-deployment.tf` which will be deployment to the cluster when the cluster is up an running
* I have also create `service.tf` which is using LoadBalancer. This will allow us to access the application externally

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
aws eks update-kubeconfig --name terraform-eks-demo --region eu-central-1
```
If you have multiple context, then you can use the following command to switch to the correct contex
```
kubectl config use-context arn:aws:eks:eu-central-1:136772758500:cluster/getting-started-eks
```
```
kubectl get nodes
NAME                                         STATUS   ROLES    AGE    VERSION
ip-10-0-1-41.eu-central-1.compute.internal   Ready    <none>   114s   v1.21.5-eks-9017834
```
```
kubectl get ns
NAME              STATUS   AGE
default           Active   4d1h
kube-node-lease   Active   4d1h
kube-public       Active   4d1h
kube-system       Active   4d1h
```
```
kubectl get pods -n default
NAME                      READY   STATUS    RESTARTS   AGE
coffee-55bf956c8d-knbwr   1/1     Running   0          4d1h
coffee-55bf956c8d-kz5vs   1/1     Running   0          4d1h
tea-84d7c495b4-4mxp6      1/1     Running   0          4d1h
tea-84d7c495b4-6nql7      1/1     Running   0          4d1h
tea-84d7c495b4-vkxt4      1/1     Running   0          4d1h
```
```
kubectl logs -f coffee-55bf956c8d-knbwr  -n default
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: /etc/nginx/conf.d/default.conf is not a file or does not exist
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2022/04/12 10:19:05 [notice] 1#1: using the "epoll" event method
2022/04/12 10:19:05 [notice] 1#1: nginx/1.21.6
2022/04/12 10:19:05 [notice] 1#1: built by gcc 10.3.1 20211027 (Alpine 10.3.1_git20211027)
2022/04/12 10:19:05 [notice] 1#1: OS: Linux 5.4.181-99.354.amzn2.x86_64
2022/04/12 10:19:05 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2022/04/12 10:19:05 [notice] 1#1: start worker processes
2022/04/12 10:19:05 [notice] 1#1: start worker process 22
2022/04/12 10:19:05 [notice] 1#1: start worker process 23
```
### TODO
This is a very basic eks cluster. In order to make it production ready cluster, we will need to make the following adjustments:
* Create and add ssh key to the nodes to access the node for maintanace and troubleshooting
* Creating an IAM OIDC identity provider for the cluster, to create IAM roles to associate with a service account in the cluster, instead of using kiam or kube2iam
* Creating role and cluster role binding for the CI/CD
* Creating role and cluster role for user managment, creating separate role for engineer and Devops/SRE
* Provision cluster using ansible or similar tools is also an option.
* Add know gpg key to the respository so that only known user could rollout changes to the cluster
* Creating a CI/CD pipeline to rollout deployment to the cluster.
* Create a make file which include lint check, code formatting and so on
* Should have dedicated IAM User or role to run terraform apply
* Integrate atlantis to the respository so that the terraform plan and apply are automated.
* Configure dynamodb for the version control of terraform state

### Monitoring
* The module allow us to enable logging so that the logs are available on cloudwatch.
* Beside this there a lot of logs shipper which could be use to ship logs e.g using logstash/filebeat to ship logs to elasticsearch cluster.
* For metric it also depend on to tool which tool we will use to monitoring the cluster. e.g cloudwatch, promethous, elasticsearch etc.
