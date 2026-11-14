pipeline {
    agent any
    environment {
        CART_SERVICE_URL = 'http://10.0.2.12:5002'
        PAYMENT_SERVICE_URL = 'https://6ownbyflwj4kopkun5ewyylc7a0kchyi.lambda-url.us-east-1.on.aws/'
        NOTIFICATION_SERVICE_URL = 'https://u7a32r2dkfxhxo6w3s6ompx5v40moajn.lambda-url.us-east-1.on.aws/'
    }
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

        stage('Deploy Order Microservice') {
            steps {
                dir('ansible') {
                    withCredentials([string(credentialsId: 'order-mongodb-uri', variable: 'MONGODB_URI'), sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
                        sh '''
                        echo "Installing Ansible collections..."

                        ansible-galaxy collection install community.general

                         ansible-playbook \
                                    -i inventory/inventory.ini \
                                     site.yaml \
                                     --limit order \
                                     --extra-vars "mongodb_uri=$MONGODB_URI" \
                                     --extra-vars "cart_service_url=$CART_SERVICE_URL" \
                                     --extra-vars "payment_lambda_function_url=$PAYMENT_SERVICE_URL" \
                                     --extra-vars "notification_lambda_function_url=$NOTIFICATION_SERVICE_URL"
                                     --private-key "$SSH_KEY" \
                                     -u "$SSH_USER"
                          '''
                    }
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Deploy Application executed successfully++++===='
                }
                failure {
                    echo '====++++Deploy Application execution failed++++===='
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
            echo '========order microservice pipeline executed successfully ========'
        }
        failure {
            echo '========order microservice pipeline execution failed========'
        }
    }
}
