## Setup Instructions for EC2 Instance with Terraform

Follow the steps below to generate an SSH key pair, configure your Terraform project, and launch your EC2 instance.

### Prerequisites

- Terraform installed
- AWS account with appropriate permissions to create EC2 instances, key pairs, and networking resources.
- SSH client to connect to the EC2 instance.

---

### Steps

### 1. Generate an SSH Key Pair

Use `ssh-keygen` to create a new RSA key pair that will be used for SSH access to your EC2 instance.

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

```

- When prompted, choose a location to save the key pair (e.g., `./key/keyname`).
- Two files will be generated:
  - `keyname` (private key)
  - `keyname.pub` (public key)

Make sure to **keep your private key secure** and note its path.

### 2. Configure Terraform

Edit your `terraform.tfvars` file to include the path to the public key and your IP address for SSH access:

```
hcl
Copy code
keypair = "./key/keyname.pub"        # Path to the public key
my_workstation_ip = "your-device-ip"      # Your local machine IPv4 address for SSH access

```

- Replace `./key/keyname.pub` with the actual path where you saved the public key.
- Replace `your-device-ip` with your current machine’s IP address (use [WhatIsMyIP](https://www.whatismyip.com/) or run `curl ifconfig.me` to find your public IP).

### 3. Initialize Terraform and Apply Configuration

Run the following commands to deploy your EC2 instance:

```bash
terraform init     # Initialize the Terraform working directory
terraform plan     # Preview the resources to be created
terraform apply    # Deploy the resources to AWS

```

- During `terraform apply`, review the changes and confirm the execution by typing `yes`.

### 4. Access Your EC2 Instance

After Terraform completes the deployment, you can SSH into your EC2 instance using the private key you generated:

```bash
ssh -i ./key/keyname ec2-user@<your-ec2-public-ip>

```

- Replace `<your-ec2-public-ip>` with the public IP of your EC2 instance (outputted by Terraform).
- Ensure the private key file (`keyname`) has correct permissions:

```bash
chmod 400 ./keykeyname/

```

---

### Notes:

- The `keypair` is passed to Terraform to set up SSH access for the EC2 instance.
- Your IP address is used to limit inbound SSH access to only your device.
