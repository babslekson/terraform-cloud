pipeline {
    agent any

    environment {
        TF_CLI_ARGS = '-no-color'
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    checkout scm
                }
            }
        }
        stage('Lint Code') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        echo "Validating Terraform configuration..."
                        sh 'terraform validate' 
                        echo "Terraform code linting completed"
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        echo "Initializing Terraform..."
                        sh 'terraform init'
                        echo "Generating terraform plan"
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { env.BRANCH_NAME == 'main' && currentBuild.rawBuild.getCause(hudson.model.Cause$UserIdCause) != null }
            }
            steps {
                script {
        //             // Automatic confirmation 
                    
                     echo " Applying Terraform changes"
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {

                
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
