# ecr-manager

Uses Terraform and Jenkins to manage ECR repositories

## Usage

1. Fork this repository into your private git hosting provider
2. Create a Jenkins multibranch pipeline job pointing to this new private repository
3. Invoke this Jenkins job from your service builds before your Docker build/tag stage
    - <https://jenkins.io/doc/pipeline/steps/pipeline-build-step>

### Notes

Calling this automation during every build will ensure that all ECR repositories are continuously updated with the same standard settings as they are changed in your centralized repository.
