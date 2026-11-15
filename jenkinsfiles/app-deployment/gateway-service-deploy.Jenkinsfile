pipeline {
    agent any
    environment {
        CATALOG_SERVICE_URL = 'http://10.0.3.11:5001'
        CART_SERVICE_URL = 'http://10.0.3.12:5002'
        ORDER_SERVICE_URL = 'http://10.0.3.13:5003'
        PAYMENT_SERVICE_URL = 'https://ejcoxagxm7vgra7btjxpznt7wm0xwmld.lambda-url.us-east-1.on.aws/'
        NOTIFICATION_SERVICE_URL = 'https://a27hvn4lmx7sddup7b7hmxtg340grtmp.lambda-url.us-east-1.on.aws/'
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

        stage('Deploy Gateway Microservice') {
            steps {
                dir('ansible') {
                    withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER'), string(credentialsId: 'jwt-secret-key', variable: 'JWT_SECRET_KEY')]) {
                        sh '''
                        echo "Installing Ansible collections..."

                        ansible-galaxy collection install community.general

                         ansible-playbook \
                                    -i inventory/inventory.ini \
                                     site.yaml \
                                     --limit gateway \
                                     --extra-vars "jwt_secret_key=$JWT_SECRET_KEY" \
                                     --extra-vars "catalog_service_url=$CATALOG_SERVICE_URL" \
                                     --extra-vars "cart_service_url=$CART_SERVICE_URL" \
                                     --extra-vars "order_service_url=$ORDER_SERVICE_URL" \
                                     --extra-vars "payment_lambda_function_url=$PAYMENT_SERVICE_URL" \
                                     --extra-vars "notification_lambda_function_url=$NOTIFICATION_SERVICE_URL" \
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
            echo '========gateway microservice pipeline executed successfully ========'
        }
        failure {
            echo '========gateway microservice pipeline execution failed========'
        }
    }
}
