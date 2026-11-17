pipeline {
    agent any
    environment {
        AWS_REGION = 'us-east-1'

        STOREFRONT_BUCKET = 'shopitry-user-frontend-prod'

        STOREFRONT_DISTRIBUTION_ID = 'E1Z3E1QNRZMMXE'
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

        stage('Install Dependencies') {
            steps {
                echo '====++++executing Install Dependencies++++===='
                dir('frontend/storefront') {
                    sh 'npm ci'
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

        stage('Build Frontend') {
            steps {
                echo '====++++executing Build Frontend++++===='
                dir('frontend/storefront') {
                    withEnv(['VITE_API_BASE_URL=https://api.suryanshsoni.online']) {
                        sh 'npm run build'
                    }
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Build Frontend executed successfully++++===='
                }
                failure {
                    echo '====++++Build Frontend execution failed++++===='
                }
            }
        }

        stage('Deploy to S3') {
            steps {
                echo '====++++executing Deploy to S3++++===='
                dir('frontend/storefront') {
                    sh '''
                    aws s3 sync dist/ s3://${STOREFRONT_BUCKET}/ \
                    --delete \
                    --region ${AWS_REGION}
                '''
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Deploy to S3 executed successfully++++===='
                }
                failure {
                    echo '====++++Deploy to S3 execution failed++++===='
                }
            }
        }

        stage('CloudFront Invalidation') {
            steps {
                echo '====++++executing CloudFront Invalidation++++===='
                dir('frontend/storefront') {
                    sh '''
                    aws cloudfront create-invalidation \
                    --distribution-id ${STOREFRONT_DISTRIBUTION_ID} \
                    --paths "/*"
                '''
                }
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++CloudFront Invalidation executed successfully++++===='
                }
                failure {
                    echo '====++++CloudFront Invalidation execution failed++++===='
                }
            }
        }
    }
    post {
        always {
            echo '========always========'
        }
        success {
            echo '========storefront frontend deploy pipeline executed successfully ========'
        }
        failure {
            echo '========storefront frontend deploy pipeline execution failed========'
        }
    }
}
