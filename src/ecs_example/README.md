This terraform example builds a starter project for an simple containerized web service running in ECS:

- **VPC**: Builds a complete VPC with two public and two private subnets, route tables, and NAT gateways for the private subnets.
- **ECS Cluster**: Builds an auto-scaling group (static size of 2) of t2.micro in the private subnets that auto-join to the `example-cluster` ECS cluster.
- **ECS Services**: Builds two ECS services, `example-static` (nginx) and `example-api` (echoserver) spread across both AZs. All container logs are written to CloudWatch and saved for 90 days.
- **ECS Ingress**: Routes incoming `/api/*` requests to `example-api`, all other traffic goes to `example-static`.
- **Bastion**: Builds a simple bastion host in the public subnet to reach the ASG instances in the private subnets. (Does not propagate ssh key, you'll need to create ~/.ssh/id_rsa on first login.)

## Setup
This creates resources in `us-west-1` to avoid potentially interacting with resource in `us-east-*`, which is where most CU resources tend to be right now. **Running this will cost you money.** Not much, and you can destroy everything when you're done, but heads up.
- Create an EC2 keypair in us-west-1 and set its name in `vars.tf` in the `key_name` variable.
- Double check the available AZs available to your account in `us-west-1` and update the `azs` attribute in `vpc.tf`.

## Running
Simply running `terraform apply` will create everything and should take ~4 minutes. Once it's complete the load balancer DNS name and bastion IP will be printed. You can then request `http://<ALB_DNS/` and `http://<ALB_DNS>/api/` to see the different service responses. (You may have to wait an additional minute or so for all containers to register with their target group and pass health checks.)

## Destroying
Runnign `terraform destroy` and answering `yes` to the prompt will clean up all terraform-managed resources from this project. These CloudWatch log groups will _not_ be deleted and will need to be manually removed:
- /var/log/dmesg
- /var/log/docker
- /var/log/ecs/ecs-agent.log
- /var/log/messages
