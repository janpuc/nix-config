{ config, ... }:
{
  home = {
    file."${config.home.homeDirectory}/Development/.kopiaignore" = {
      text = ''
        # Ignore dependency directories
        **/node_modules/
        **/.cache/
        **/.tmp/

        # Ignore log files
        *.log

        # Common build outputs (add as needed)
        **/bin/
        **/obj/
        **/dist/
        **/build/
        **/*.pyc
        **/__pycache__/

        # OS-specific files (especially for macOS)
        .DS_Store
        ._*

        # IDE and editor directories
        .vscode/
        .idea/
        *.swp
        *.swo

        # Terraform/OpenTofu specific ignores
        **/.terraform/
        **/.terraform.lock.hcl
        **/terraform.tfstate
        **/terraform.tfstate.backup
        **/*.tfplan
        **/.terraform.tfstate.lock.info
        **/.terraform-providers/
        **/.terraform-docs.yml

        # Terragrunt specific ignores
        **/.terragrunt-cache/
        **/.terragrunt-source-manifest
        **/.terragrunt-source-version

        # OpenTofu specific ignores (if different from Terraform)
        **/.opentofu/
        **/.tofu/
        **/.tofu.lock.hcl

        # Common provider cache directories
        **/.terraform.d/
        **/terraform.d/
        **/tofu.d/

        # Common cache directories for these tools
        **/.cache/terraform/
        **/.cache/terragrunt/
        **/.cache/opentofu/
      '';
      force = true;
    };
  };
}
