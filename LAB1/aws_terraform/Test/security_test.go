package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleSecurity(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../modules/security", // Đường dẫn tới thư mục chứa module security

		Vars: map[string]interface{}{
			"vpc_id":            "vpc-0123456789abcdef",
			"my_workstation_ip": "103.199.71.65/32",
		},
	}

	// Dọn dẹp tài nguyên sau khi kiểm tra
	defer terraform.Destroy(t, options)

	// Khởi tạo và áp dụng cấu hình Terraform
	terraform.InitAndApply(t, options)

	// Kiểm tra rằng nhóm bảo mật công khai đã được tạo
	publicSGID := terraform.Output(t, options, "public_instance_security_group_id")
	assert.NotEmpty(t, publicSGID)

	// Kiểm tra rằng nhóm bảo mật riêng đã được tạo
	privateSGID := terraform.Output(t, options, "private_instance_security_group_id")
	assert.NotEmpty(t, privateSGID)
}
