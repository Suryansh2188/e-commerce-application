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

        stage('Deploy Cart Microservice') {
            steps {
                dir('ansible') {
                    withCredentials([string(credentialsId: 'cart-mongodb-uri', variable: 'MONGODB_URI')]) {
                        sh '''
                        echo "Installing Ansible collections..."

                        ansible-galaxy collection install community.general

                         ansible-playbook \
                                    -i inventory/inventory.ini \
                                     site.yaml \
                                     --limit cart \
                                     --extra-vars "mongodb_uri=$MONGODB_URI"
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
        }
        success {
            echo '========cart microservice pipeline executed successfully ========'
        }
        failure {
            echo '========cart microservice pipeline execution failed========'
        }
    }
}
