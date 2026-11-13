pipeline{
    agent any

    environment {
        INSTANCE_ID = 'i-0b188089b9df7ebac'
        KEY_NAME = 'uskey'
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
                dir('shopitry-infrastructure-terrafrom') {
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
                dir('shopitry-infrastructure-terrafrom') {
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
                dir('shopitry-infrastructure-terrafrom') {
                    sh '''
                    terraform destroy --auto-approve \
                    -var="instance_id=${INSTANCE_ID}" \
                    -var="key_name=${KEY_NAME}"
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
        }
        success{
            echo "========pipeline executed successfully ========"
        }
        failure{
            echo "========pipeline execution failed========"
        }
    }
}