pipeline{
    agent any
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

        stage("infra-destroy-stage"){
            steps{
                dir('shopitry-infrastructure-terrafrom') {
                    sh 'terraform destroy --auto-approve'
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