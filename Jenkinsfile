pipeline {
    agent any

    stages {
        stage('Clone') {
            steps {
                git branch: 'main', url: 'https://github.com/abdullahashrafdev/memos.git'
            }
        }

        stage('Build') {
            steps {
                sh 'docker-compose -f docker-compose.jenkins.yml up -d --build'
            }
        }
    }
}