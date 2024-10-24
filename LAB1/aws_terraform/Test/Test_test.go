package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformInfrastructure(t *testing.T) {
	// Thiết lập các tùy chọn cho Terraform
	opts := &terraform.Options{
		// Đường dẫn tới thư mục chứa Terraform code
		TerraformDir: "../modules/security",

		// Biến môi trường
		Vars: map[string]interface{}{
			"region":             "ap-northeast-1",
			"profile":            "default",
			"vpc_cidr":           "10.16.0.0/16",
			"public_subnets":     []string{"10.16.32.0/20", "10.16.96.0/20", "10.16.160.0/20"},
			"private_subnets":    []string{"10.16.48.0/20", "10.16.112.0/20", "10.16.176.0/20"},
			"keypair":            "./key/tokyo.pub",
			"instance_type":      "t2.micro",
			"availability_zones": []string{"ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"},
			"my_workstation_ip":  "171.250.165.116/32",
		},

		// Thiết lập biến môi trường nếu cần thiết
		EnvVars: map[string]string{
			"AWS_DEFAULT_REGION": "ap-northeast-1",
			"AWS_PROFILE":        "default",
		},
	}

	// Dọn dẹp sau khi test
	defer terraform.Destroy(t, opts)

	// Khởi động Terraform
	terraform.InitAndApply(t, opts)

	// Kiểm tra đầu ra
	vpcID := terraform.Output(t, opts, "vpc_id")
	assert.NotEmpty(t, vpcID)

	publicSubnets := terraform.OutputList(t, opts, "public_subnet_ids")
	assert.Len(t, publicSubnets, 3)

	privateSubnets := terraform.OutputList(t, opts, "private_subnet_ids")
	assert.Len(t, privateSubnets, 3)

	publicInstanceIDs := terraform.OutputList(t, opts, "public_instance_ids")
	assert.Len(t, publicInstanceIDs, 1)

	privateInstanceIDs := terraform.OutputList(t, opts, "private_instance_ids")
	assert.Len(t, privateInstanceIDs, 1)
}
