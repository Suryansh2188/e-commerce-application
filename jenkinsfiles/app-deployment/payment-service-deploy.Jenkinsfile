pipeline {
    agent any
    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', poll: false, url: 'https://github.com/Suryansh2188/e-commerce-application.git'
            }
            post {
                always {
                    echo '========always========'
                }
                success {
                    echo '========Checkout Code executed successfully========'
                }
                failure {
                    echo '========Checkout Code execution failed========'
                }
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('backend/payment-service') {
                    sh 'npm install --production'
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Install Dependencies executed successfully++++===='
                }
                failure {
                    echo '====++++Install Dependencies execution failed++++===='
                }
            }
        }

        stage('Create Deployment Package Artifact') {
            steps {
                dir('backend/payment-service') {
                    sh '''
                      rm -f payment-service.zip \
                      zip -r payment-service.zip src node_modules package.json
                    '''
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Create deployment package artifact executed successfully++++===='
                }
                failure {
                    echo '====++++Create deployment package artifact execution failed++++===='
                }
            }
        }

        stage('Upload Artifact') {
            steps {
                dir('backend/payment-service') {
                    sh '''
                   aws lambda update-function-code \
                      --function-name shopitry-payment-service \
                      --zip-file fileb://payment-service.zip \
                      --publish

                      aws lambda update-function-configuration \
                         --function-name shopitry-payment-service \
                         --environment "Variables={PAYMENT_GATEWAY_MODE=PRODUCTION}"
                    '''
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Upload Artifact executed successfully++++===='
                }
                failure {
                    echo '====++++Upload Artifact execution failed++++===='
                }
            }
        }
    }
    post {
        always {
            echo '========always========'
            cleanWs()
        }
        success {
            echo '========payment microservice pipeline executed successfully ========'
        }
        failure {
            echo '========payment microservice pipeline execution failed========'
        }
    }
}
