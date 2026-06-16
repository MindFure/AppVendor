pipeline {
    agent any

    parameters {
        string(name: 'BRANCH', defaultValue: 'main', description: 'Какую ветку репозитория деплоить?')
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Deploy via Ansible') {
            steps {
                ansiblePlaybook(
                    playbook: 'deploy/ansible/playbook.yml', 
                    inventory: 'deploy/ansible/inventory/hosts.init', 
                    credentialsId: 'vm-ssh-key',    
                    colorized: true,                // Чтобы логи были цветными и красивыми
                    extraVars: [
                        repo_branch: "${params.BRANCH}"
                    ]
                )
            }
        }
    }
}