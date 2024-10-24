package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestModuleNetworking(t *testing.T) {
	options := &terraform.Options{
		TerraformDir: "../modules/networking", // Đường dẫn tới thư mục chứa module networking

		Vars: map[string]interface{}{
			"vpc_cidr":           "10.16.0.0/16",
			"public_subnets":     []string{"10.16.32.0/20", "10.16.96.0/20"},
			"private_subnets":    []string{"10.16.48.0/20", "10.16.112.0/20"},
			"availability_zones": []string{"ap-northeast-1a", "ap-northeast-1c"},
		},
	}

	// Dọn dẹp tài nguyên sau khi kiểm tra
	defer terraform.Destroy(t, options)

	// Khởi tạo và áp dụng cấu hình Terraform
	terraform.InitAndApply(t, options)

	// Kiểm tra rằng VPC ID đã được tạo
	vpcID := terraform.Output(t, options, "vpc_id")
	assert.NotEmpty(t, vpcID)

	// Kiểm tra rằng các subnet công khai đã được tạo
	publicSubnetIDs := terraform.OutputList(t, options, "public_subnet_ids")
	assert.Len(t, publicSubnetIDs, 2)

	// Kiểm tra rằng các subnet riêng đã được tạo
	privateSubnetIDs := terraform.OutputList(t, options, "private_subnet_ids")
	assert.Len(t, privateSubnetIDs, 2)
}
