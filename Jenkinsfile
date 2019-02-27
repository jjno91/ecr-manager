pipeline {
  agent {
    kubernetes {
      label UUID.randomUUID().toString()
      containerTemplate {
        name 'this'
        image 'hashicorp/terraform'
        ttyEnabled true
        command 'cat'
      }
    }
  }

  options {
    buildDiscarder(logRotator(numToKeepStr: '30'))
  }

  environment {
    AWS_ACCESS_KEY_ID = credentials('aws.id')
    AWS_SECRET_ACCESS_KEY = credentials('aws.key')
    STATE_BUCKET = "your-state-bucket"
    STATE_REGION = "us-east-1"
  }

  parameters {
    string(name: 'REPOSITORY_NAME', defaultValue: 'ecr-manager-test', description: 'Name of the ECR repository to be created/updated')
    string(name: 'COST_CENTER', defaultValue: 'IT', description: 'Used to track ongoing costs for the repository')
    string(name: 'REGION', defaultValue: 'us-east-1', description: 'Region in which the repository will be created')
    booleanParam(name: 'DRY_RUN', defaultValue: false, description: 'Prevent the "Apply" stage from running')
  }

  stages {
    stage('Initialize') {
      steps {
        container('this') {
          sh '''
            export TF_VAR_creator=$(git config --get remote.origin.url)
            export TF_VAR_repository_name=$REPOSITORY_NAME
            export TF_VAR_cost_center=$COST_CENTER
            export TF_VAR_region=$REGION

            terraform init \\
              -backend-config "bucket=$STATE_BUCKET" \\
              -backend-config "region=$STATE_REGION" \\
              -backend-config "key=ecr-manager/$REPOSITORY_NAME.tfstate" \\
              -backend-config "encrypt=true"
          '''
        }
      }
    }
    stage('Plan') {
      steps {
        container('this') {
          sh '''
            export TF_VAR_creator=$(git config --get remote.origin.url)
            export TF_VAR_repository_name=$REPOSITORY_NAME
            export TF_VAR_cost_center=$COST_CENTER
            export TF_VAR_region=$REGION
            
            terraform plan -input=false -out .tfplan
          '''
        }
      }
    }
    stage('Apply') {
      when {
        allOf {
          branch "master"
          environment name: DRY_RUN, value: false
        }
      }
      steps {
        container('this') {
          sh 'terraform apply -input=false -auto-approve .tfplan'
        }
      }
    }
  }
}
