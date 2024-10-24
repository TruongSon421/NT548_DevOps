package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleComputing(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../modules/computing", // Đường dẫn tới thư mục chứa module computing

		Vars: map[string]interface{}{
			"public_instance_security_group_id":  "sg-0123456789abcdef0",
			"private_instance_security_group_id": "sg-0123456789abcdef1",
			"public_subnet_ids":                  []string{"subnet-0123456789abcdef0"},
			"private_subnet_ids":                 []string{"subnet-0123456789abcdef1"},
			"vpc_id":                             "vpc-0123456789abcdef",
			"instance_type":                      "t2.micro",
			"keypair":                            "./key/tokyo.pub",
		},
	}

	// Dọn dẹp tài nguyên sau khi kiểm tra
	defer terraform.Destroy(t, options)

	// Khởi tạo và áp dụng cấu hình Terraform
	terraform.InitAndApply(t, options)

	// Kiểm tra rằng instance công khai đã được tạo
	publicInstanceID := terraform.Output(t, options, "public_instance_id")
	assert.NotEmpty(t, publicInstanceID)

	// Kiểm tra rằng instance riêng đã được tạo
	privateInstanceID := terraform.Output(t, options, "private_instance_id")
	assert.NotEmpty(t, privateInstanceID)

	// Kiểm tra rằng IP công khai đã được cấp
	publicIP := terraform.Output(t, options, "public_instance_ip")
	assert.NotEmpty(t, publicIP)

	// Kiểm tra rằng IP riêng đã được cấp
	privateIP := terraform.Output(t, options, "private_instance_private_ip")
	assert.NotEmpty(t, privateIP)

	// Kiểm tra rằng AMI ID đã được định nghĩa
	amiID := terraform.Output(t, options, "ami_id")
	assert.NotEmpty(t, amiID)
}
