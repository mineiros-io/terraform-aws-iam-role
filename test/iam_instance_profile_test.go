package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/aws"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// TestIAMInstanceProfile tests the creation of the IAM Instance Profile
func TestIAMInstanceProfile(t *testing.T) {
	t.Parallel()

	randomAwsRegion := aws.GetRandomRegion(t, nil, nil)

	terraformOptions := &terraform.Options{
		// The path to where your Terraform code is located
		TerraformDir: "./iam-instance-profile",
		Vars: map[string]interface{}{
			"aws_region": randomAwsRegion,
		},
		Upgrade: true,
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

}
