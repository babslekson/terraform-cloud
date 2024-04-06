pipeline {
    agent any  // Defines that this pipeline can run on any available agent

    environment {
        TF_CLI_ARGS = '-no-color' // Sets Terraform CLI arguments to disable color output
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    // Checkout the source code from the repository
                    checkout scm
                }
            }
        }
        stage('Lint Code') {
            steps {
                script {
                    withCredentials([aws(credentialsId: 'AWS_CRED', accessKeyVariable: 'AWS_ACCESS_KEY_ID', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                         // Validate the syntax, consistency, and correctness of Terraform configuration files
                        echo "Validating Terraform configuration..."
                        sh 'terraform init'
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

            post {
                success {
                    // If Terraform apply succeeds, perform cleanup
                    cleanup()
                }
                failure {
                    // If Terraform apply fails, handle the error gracefully
                    echo 'Terraform apply failed. Sending notification...'
                    // Add code to send notification or log detailed error messages
                    cleanup()
                }
            }
        }

        stage('Cleanup') {
            steps {
                script {
                    // Clean up any temporary files or state
                    echo 'Cleaning up...'
                    // Add commands to clean up any temporary files or state
                }
            }
        }
        
    }
