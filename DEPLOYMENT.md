# AWS deployment guide

This guide describes the deployment workflow represented by the repository. It is an operator checklist, not a fully automated account bootstrap: DNS delegation, ACM certificate issuance, Jenkins host preparation, and some environment-specific values must be prepared separately.

## Deployment architecture

- **Jenkins host:** one EC2 instance in the default VPC. It runs the Jenkins jobs and uses an attached IAM role for AWS access.
- **Application VPC:** Terraform creates a VPC with public and private subnets in two availability zones, internet/NAT gateways, and VPC peering and routes to the default VPC.
- **Application instances:** the gateway runs on a public EC2 instance; catalog, cart, and order run on private EC2 instances. Terraform currently wires the service instances to subnet IDs in `us-east-1a`, so the current compute deployment is not spread across both AZs.
- **Public API:** an Application Load Balancer accepts HTTP/HTTPS and forwards HTTPS API traffic to the gateway target group.
- **Frontends:** the storefront and admin dashboard are deployed to separate S3 buckets and served through CloudFront distributions with private S3 origins.
- **Serverless services:** Terraform creates payment and notification Lambda resources and Function URLs. The Terraform module currently packages placeholder handlers; the application deployment jobs must publish the intended code.
- **Database:** the Node.js data services connect to MongoDB Atlas using environment configuration.

The gateway is an application running on EC2, not the managed Amazon API Gateway service.

## 1. Prepare AWS and Jenkins

Before running a pipeline:

1. Create the Jenkins EC2 host in the default VPC. Attach a least-privilege IAM instance profile for the AWS resources and actions the jobs require; avoid long-lived AWS access keys on the host.
2. Install and verify the tools used by the jobs: Jenkins, Git, AWS CLI, Node.js/npm, Terraform, Ansible, and SSH utilities.
3. Configure Jenkins credentials for the EC2 SSH private key and any application/database secrets. The configuration pipeline expects an SSH credential; do not put private keys, passwords, or tokens in Jenkinsfiles or the repository.
4. Create the Terraform state bucket expected by `shopitry-infrastructure-terraform/backend.tf` before the first `terraform init`. Enable encryption and versioning, and allow the Jenkins role to access the state and S3 lock file.
5. Confirm the Jenkins host can reach the application VPC over the configured VPC peering connection and can SSH to the application instances using the intended private IPs.

## 2. Prepare DNS, certificates, and Terraform inputs

1. Create a Route 53 hosted zone for the domain and delegate its assigned name servers at the domain registrar.
2. Request and validate ACM certificates for the frontend names and API name. CloudFront requires its ACM certificate in `us-east-1`; the current Terraform uses the certificate ARN for both CloudFront and the load balancer, so confirm that it is usable in the configured AWS region and covers the configured names.
3. Review `shopitry-infrastructure-terraform/terraform.tfvars.example` and replace all example/environment-specific values, including region, domain names, bucket names, instance settings, subnets, and service addresses.
4. Review the infrastructure Jenkinsfile before use. It copies `terraform.tfvars.example` to `terraform.tfvars` in the workspace and supplies several additional Terraform variables from the Jenkinsfile. The checked-in example contains values that must be validated for your environment. Keep populated `terraform.tfvars` out of source control.
5. Route 53 records and ACM certificate requests are not created by the Terraform modules in this repository; plan to configure them separately.

## 3. Provision infrastructure

Run `jenkinsfiles/infra-jenkinsfile/Jenkinsfile` from a Jenkins pipeline. Its stages:

1. Check out the repository.
2. Prepare `terraform.tfvars`.
3. Run `terraform init` and `terraform validate`.
4. Generate a Terraform plan.
5. Pause for approval.
6. Apply the approved plan.

Review the plan carefully before approval, especially networking, public ingress, IAM policies, Lambda Function URL access, and any resource replacement. Use the Terraform outputs to retrieve the VPC/subnet IDs, service IPs, load balancer details, Lambda URLs, S3 bucket names, and CloudFront distribution details needed by later steps.

## 4. Configure EC2 instances

After infrastructure is available:

1. Update `ansible/inventory/inventory.ini` with the actual private addresses for the gateway, catalog, cart, and order instances.
2. Run `jenkinsfiles/configuration-jenkinsfile/config.Jenkinsfile`.
3. The job checks SSH connectivity, checks the Ansible playbook syntax, and runs `ansible/playbooks/bootstrap.yaml`. The playbook applies the roles for Node.js/PM2 and the gateway, catalog, cart, and order applications.
4. Verify that the SSH user, private key, Python interpreter, security groups, routes, and host addresses are correct if connectivity fails.

## 5. Deploy application components

Run the matching pipeline under `jenkinsfiles/app-deployment/` for each component:

| Component | Jenkinsfile |
| --- | --- |
| Gateway | `gateway-service-deploy.Jenkinsfile` |
| Catalog | `catalog-deploy.Jenkinsfile` |
| Cart | `cart-deploy.Jenkinsfile` |
| Orders | `order-deploy.Jenkinsfile` |
| Payment function | `payment-service-deploy.Jenkinsfile` |
| Notification function | `notification-service-deploy.Jenkinsfile` |
| Storefront | `storefront-frontend-deploy.Jenkinsfile` |
| Admin dashboard | `admin-frontend-deploy.Jenkinsfile` |

Set service URLs, database URIs, JWT settings, function URLs, and frontend API settings through the appropriate Jenkins credentials or deployment environment configuration. Do not copy production values into source files. Confirm the Lambda deployment pipelines replace the placeholder code provisioned by Terraform.

## 6. Configure DNS and verify

After deployments complete:

1. Create DNS aliases/records for the storefront and admin CloudFront distributions.
2. Create the API DNS record pointing to the Application Load Balancer.
3. Wait for DNS and certificate validation/propagation.
4. Test the storefront and admin pages over HTTPS, then test the API health endpoint and representative catalog, cart, and order operations.
5. Check Jenkins build logs, EC2 service/process health, Lambda logs, and load balancer target health. Avoid placing secret values in build logs.

## Operational and security notes

- The Lambda Function URLs in the current Terraform code use `authorization_type = "NONE"` and allow public invocation. Restrict or add application-level authorization before production use.
- Review security group rules and IAM permissions for least privilege. Ensure private service ports are not publicly reachable.
- Protect Terraform state as sensitive data. Use a separate backend/state key per environment and do not commit generated state or `terraform.tfvars`.
- The current infrastructure Jenkinsfile contains environment-specific resource values. Prefer managed Jenkins parameters for non-secret configuration and Jenkins credentials for secrets.
- A destroy pipeline is present in `jenkinsfiles/infra-jenkinsfile/destroy-infra.Jenkinsfile`. Treat it as destructive: verify the AWS account, workspace, state, and plan before approving any destroy operation.
- A previous version of this guide included database credentials. Those values have been removed from the current file, but removing them here does not erase Git history. Rotate any credentials that may have been committed and review repository history.
