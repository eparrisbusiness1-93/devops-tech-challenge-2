pipeline {
    agent any

    environment {
        AWS_REGION     = 'us-east-2'
        CLUSTER_NAME   = 'tech-challenge-eks'
        IMAGE_NAME     = 'hello-world-app'
        AWS_ACCOUNT_ID = '444896211196'
        ECR_REPO_URL   = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    sh "docker build -t ${ECR_REPO_URL}:${BUILD_NUMBER} ."
                    sh "docker tag ${ECR_REPO_URL}:${BUILD_NUMBER} ${ECR_REPO_URL}:latest"
                }
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_REPO_URL}"
            }
        }

        stage('Push Image to ECR') {
            steps {
                sh "docker push ${ECR_REPO_URL}:${BUILD_NUMBER}"
                sh "docker push ${ECR_REPO_URL}:latest"
            }
        }

        stage('Update Kubeconfig') {
            steps {
                sh "aws eks update-kubeconfig --region ${AWS_REGION} --name ${CLUSTER_NAME}"
            }
        }

        stage('Deploy to EKS via Helm') {
            steps {
                sh """
                helm upgrade --install hello-world-release ./helm \
                  --set image.repository=${ECR_REPO_URL} \
                  --set image.tag=${BUILD_NUMBER}
                """
            }
        }
    }

    post {
        success {
            echo "Successfully built and deployed build #${BUILD_NUMBER} to EKS!"
        }
        failure {
            echo "Pipeline failed. Check stage logs for details."
        }
    }
}