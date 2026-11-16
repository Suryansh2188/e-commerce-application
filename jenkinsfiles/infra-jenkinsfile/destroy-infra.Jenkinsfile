pipeline{
    agent any

    environment {
        INSTANCE_ID = 'i-0b188089b9df7ebac'
        KEY_NAME = 'uskey'
        ACM_CERTIFICATE_ARN = 'arn:aws:acm:us-east-1:202906063966:certificate/f79c80cf-fb65-4ffb-8fa7-8ac81569e6ff'
    }

    stages{
        stage("checkout-code-stage"){
            steps{
                git branch: 'main', poll: false, url: 'https://github.com/Suryansh2188/e-commerce-application.git'
            }
            post{
                always{
                    echo "========always========"
                }
                success{
                    echo "========checkout-code-stage executed successfully========"
                }
                failure{
                    echo "========checkout-code-stage execution failed========"
                }
            }
        }

        stage("copy-tfvars-file-stage"){
            steps{
                dir('shopitry-infrastructure-terraform') {
                    sh 'cp terraform.tfvars.example terraform.tfvars'
                }
            }
            post{
                always{
                    echo "====++++always++++===="
                }
                success{
                    echo "====++++change-directory-stage executed successfully++++===="
                }
                failure{
                    echo "====++++change-directory-stage execution failed++++===="
                }
        
            }
        }

        stage("terraform-init-stage"){
            steps{
                dir('shopitry-infrastructure-terraform') {
                    sh 'terraform init'
                }
            }
            post{
                always{
                    echo "====++++always++++===="
                }
                success{
                    echo "====++++terraform-init-stage executed successfully++++===="
                }
                failure{
                    echo "====++++terraform-init-stage execution failed++++===="
                }
        
            }
        }

        stage("infra-destroy-stage"){
            steps{
                dir('shopitry-infrastructure-terraform') {
                    sh '''
                    terraform destroy --auto-approve \
                    -var="instance_id=${INSTANCE_ID}" \
                    -var="key_name=${KEY_NAME}" \
                    -var="acm_certificate_arn=${ACM_CERTIFICATE_ARN}"
                '''
                }
            }
            post{
                always{
                    echo "====++++always++++===="
                }
                success{
                    echo "====++++infra-destroy-stage executed successfully++++===="
                }
                failure{
                    echo "====++++infra-destroy-stage execution failed++++===="
                }
        
            }
        }
    }
    post{
        always{
            echo "========always========"
            cleanWs()
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}