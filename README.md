# Terraform-EKS-setup
This repository contains Terraform configurations to provision a private Amazon EKS cluster along with supporting infrastructure on AWS. 


Step-by-Step Instructions for Setting Up the Desired Infrastructure Using Terraform

Prerequisites
1.  Install Terraform: Download and install the latest Terraform version from terraform.io.
2.  AWS CLI Configuration: Install and configure the AWS CLI.
    Run aws configure and provide your:
        AWS Access Key
        AWS Secret Key
        Default Region
        Output format (e.g., JSON).
3.  IAM Permissions:
    Ensure your AWS credentials have sufficient permissions:
        Create and manage EKS clusters.
        Configure IAM roles and policies.
        Create and manage S3 buckets.
    Recommended policies:
        AdministratorAccess (for simplicity in dev environments).
4.  Kubernetes Tools:
        Install kubectl for managing the Kubernetes cluster.
        Install aws-iam-authenticator for EKS authentication.

Execution Steps
1. Clone or Prepare the Directory
        Clone the repository or prepare the directory structure with the provided code.

2. Initialize Terraform
        In the root directory, run:
           $ terraform init
        This initializes the working directory and downloads necessary provider plugins.

3. Validate the Terraform Code
        Ensure there are no syntax or configuration errors:

           $ terraform validate

4. Create an Execution Plan
        Preview the resources Terraform will create:

           $ terraform plan
        Review the planned actions.

5. Apply the Terraform Configuration
        Deploy the infrastructure:

           $ terraform apply
        Type yes to confirm.

6. Verify EKS Cluster
    Update the kubectl configuration:

    $ aws eks update-kubeconfig --region <region> --name <cluster-name>

    Verify the cluster is reachable:

    $ kubectl get svc

7. Test Namespace and CIDR Ranges
    Verify namespaces:

    $ kubectl get namespaces
    Confirm that the namespaces group-a and group-b are created.

8. Verify S3 Bucket
    Check the S3 bucket in the AWS Management Console or use the CLI:

    $ aws s3 ls

9. Clean Up
    To destroy all resources, use:

    $ terraform destroy