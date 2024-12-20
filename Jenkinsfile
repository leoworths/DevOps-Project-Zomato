pipeline {
    agent any
    tools {
        jdk 'jdk17'
        nodejs 'nodejs'
    }
    environment {
        SCANNER_HOME=tool 'sonar-scanner'
        ECR_REPO_NAME = 'zomato-repo'
    }
    stages {
        stage ("clean workspace") {
            steps {
                cleanWs()
            }
        }
        stage ("Git Checkout") {
            steps {
                git branch: 'main', credentialsId: 'git-cred', url: 'https://github.com/leoworths/DevOps-Project-Zomato.git'
            }
        }
        stage("Sonarqube Analysis"){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh """ $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=zomato \
                    -Dsonar.projectKey=zomato """
                }
            }
        }
        stage("Code Quality Gate"){
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token'
                }
            } 
        }
        stage("Install NPM Dependencies") {
            steps {
                sh "npm install"
            }
        }
        stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'owasp'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage ("Build Docker Image") {
            steps {
                    sh "docker build -t ${ECR_REPO_NAME} ."
            }
        }
        stage('Docker Image Scan') {
            steps{
                sh "trivy image ${ECR_REPO_NAME} > trivy-report.txt "
            }
        }
        stage("Create ECR Repository & Login") {
            steps {
                script {
                    withCredentials([string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT_ID'), aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        def ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
                        sh "aws ecr describe-repositories --repository-names ${ECR_REPO_NAME} || aws ecr create-repository --repository-name ${ECR_REPO_NAME}"
                        sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ECR_URL}"
                    }
                }
            }
        }
        stage("Tag & Push to ECR"){
            steps{
                script{
                    withCredentials([string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT_ID'), aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        def ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
                        sh """
                            docker tag ${ECR_REPO_NAME} ${ECR_URL}/${ECR_REPO_NAME}:latest
                            docker push ${ECR_URL}/${ECR_REPO_NAME}:latest
                            """
                    }
                }
            }
        }
        stage("Trivy Image Scan") {
            steps{
                script{
                    withCredentials([string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT_ID'), aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        def ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
                        sh "trivy image --severity HIGH,CRITICAL --format table -o scan-results.txt ${ECR_URL}/${ECR_REPO_NAME}:latest"
                    }
                }
            }
        }
        stage("Cleanup Docker Images") {
            steps {
                script{
                    withCredentials([string(credentialsId: 'aws-account-id', variable: 'AWS_ACCOUNT_ID'), aws(accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-cred', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        def ECR_URL = "${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com"
                        sh "docker rmi -f ${ECR_REPO_NAME}"
                        sh "docker rmi -f ${ECR_URL}/${ECR_REPO_NAME}:latest"
                    }
                }
            }
        }
    }
}
