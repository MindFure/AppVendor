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
                    playbook: 'ansible/playbook.yml', // Путь к плейбуку в репозитории
                    inventory: 'ansible/inventory/hosts.ini', // Путь к файлу с IP сервера
                    credentialsId: 'vm-ssh-key',    // Тот самый ID ключа, который ты создал в Jenkins!
                    colorized: true,                // Чтобы логи были цветными и красивыми
                    extraVars: [
                        repo_branch: "${params.BRANCH}"
                    ]
                )
            }
        }
    }
}
