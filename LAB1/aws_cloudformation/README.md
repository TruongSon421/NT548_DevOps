## Setup Instructions for EC2 Instance with CloudFormation

Follow the steps below to generate an key pair, configure your CloudFormation Stack , and launch your EC2 instance.

### Prerequisites

- CloudFormation installed
- AWS account with appropriate permissions to create EC2 instances, key pairs, and networking resources.
- SSH client to connect to the EC2 instance.

---

### Steps

### 1. Generate an Key Pair

Use `aws ec2 create-key-pair` to create a new RSA key pair that will be used for SSH access to your EC2 instance.

```bash
aws ec2 create-key-pair --key-name <namekeypair>

```


### 2. Configure CloudFormation Stack

Edit your `parameter.json` file to include the path to the key name and your IP address for SSH access:

```json
    {
        "ParameterKey": "AllowedSSHIP",
        "ParameterValue": "your-device-ip" 
    },
    {
        "ParameterKey": "KeyPairName",
        "ParameterValue": "namekeypair"
    }
```

- Replace `namekeypair` with name key pair you create .
- Replace `your-device-ip` with your current machine’s IP address (use [WhatIsMyIP](https://www.whatismyip.com/) or run `curl ifconfig.me` to find your public IP).

### 3. Initialize CloudFormation Nested Stack and Apply Configuration

Run the following commands to deploy your EC2 instance:

```bash
# Check and verify the validity of the stacks
cfn-lint **/*.yml  
# Upload nested stack to S3
aws s3 cp /path/to/your/directory s3://your-bucket-name/ --recursive --exclude "*" --include "*.yml" 
# Deploy the resources to AWS
aws cloudformation create-stack \
    --stack-name <nameStack>   \
    --template-body file://path/to/your/template.yaml   \
    --parameters file://path/to/your/parameter.json   \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
# Check status of Stack
aws cloudformation describe-stacks --stack-name <your-stack-name>
# Destroy Stack
aws cloudformation delete-stack --stack-name <your-stack-name>
```