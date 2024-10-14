## Setup Instructions for EC2 Instance with CloudFormation

Follow the steps below to generate an key pair, configure your CloudFormation Stack , and launch your EC2 instance.

### Prerequisites

- CloudFormation installed
- AWS account with appropriate permissions to create EC2 instances, key pairs, and networking resources.
- SSH client to connect to the EC2 instance.

---

### Steps

```bash
cd .\LAB1\aws_cloudformation\
```

### 1. Create a S3 Bucket.

```bash
aws s3api create-bucket --bucket <s3_bucket_name> --region <your_region>
```

### 2. Generate a Key Pair

Use `aws ec2 create-key-pair` to create a new RSA key pair that will be used for SSH access to your EC2 instance.

```bash
aws ec2 create-key-pair --key-name <namekeypair>
```


### 3. Configure CloudFormation

Edit your `parameter.json` file to include the path to the key name and your IP address for SSH access:

```json
    {
        "ParameterKey": "AllowedSSHIP",
        "ParameterValue": "<your-device-ip>" 
    },
    {
        "ParameterKey": "KeyPairName",
        "ParameterValue": "<namekeypair>"
    }
```

- Replace `namekeypair` with the name of your key pair.
- Replace `your-device-ip` with your current machine’s IP address (use [WhatIsMyIP](https://www.whatismyip.com/) or run `curl ifconfig.me` to find your public IP).

### 4. Initialize CloudFormation Nested Stack and Apply Configuration

Run the following commands to deploy your EC2 instance:

```bash
# Check and verify the validity of the stacks
cfn-lint **/*.yml  
# Upload nested stack to S3
aws s3 cp .\nested_stack s3://your-bucket-name/ --recursive --exclude "*" --include "*.yml" 
# Deploy the resources to AWS
aws cloudformation create-stack \
    --stack-name <nameStack>   \
    --template-body file://networking.yaml   \
    --parameters file://parameter.json   \
    --capabilities CAPABILITY_IAM CAPABILITY_AUTO_EXPAND
# Check status of Stack
aws cloudformation describe-stacks --stack-name <your-stack-name>
# Destroy Stack
aws cloudformation delete-stack --stack-name <your-stack-name>
```

### 5.Implement test case with TaskCat

Install package
```bash
pip install taskcat 
```

Run test command
```bash
taskcat test run
```

