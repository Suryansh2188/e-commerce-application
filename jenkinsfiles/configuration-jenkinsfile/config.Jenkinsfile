pipeline {
    agent any

    environment {
        KEY_FILE_NAME = 'connect_instances.sh'
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
                    echo '========checkout-code-stage executed successfully========'
                }
                failure {
                    echo '========checkout-code-stage execution failed========'
                }
            }
        }

        stage('Set SSH Key Permissions') {
            steps {
                sh 'chmod 700 ${KEY_FILE_NAME}'
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++give-r-w-x-permission executed successfully++++===='
                }
                failure {
                    echo '====++++give-r-w-x-permission execution failed++++===='
                }
            }
        }

        stage('Check Microservices Instance Connectivity') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'SSH_KEY', usernameVariable: 'SSH_USER')]) {
    sh '''
                        echo "Running connectivity script..."

                        bash ./check_connectivity.sh
                    '''
}
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++check-microservices-instance-connectivity-stage executed successfully++++===='
                }
                failure {
                    echo '====++++check-microservices-instance-connectivity-stage execution failed++++===='
                }
            }
        }

        // stage('Configure Microservices Instance') {
        //     steps {
        //         dir('ansible') {
        //             sh '''ansible-galaxy collection install community.general
        //                   ansible-playbook playbooks/bootstrap.yaml --syntax-check
        //                   ansible-playbook playbooks/bootstrap.yaml
        //                '''
        //         }
        //     }
        //     post {
        //         always {
        //             echo '====++++always++++===='
        //         }
        //         success {
        //             echo '====++++Configure Microservices Instance executed successfully++++===='
        //         }
        //         failure {
        //             echo '====++++Configure Microservices Instance execution failed++++===='
        //         }
        //     }
        // }
    }
    post {
        always {
            echo '========always========'
            cleanWs()
        }
        success {
            echo '========configure microservices instance pipeline executed successfully ========'
        }
        failure {
            echo '========configure microservices instance pipeline execution failed========'
        }
    }
}
