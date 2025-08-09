pipeline {
    agent any

    environment {
        APP_NAME = "MeuApp"
        VERSION = "1.0.0"
        DEPLOY_ENV = "${params.AMBIENTE}"
    }

    options {
        timeout(time: 30, unit: 'MINUTES')
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }

    parameters {
        string(name: 'AMBIENTE', defaultValue: 'dev', description: 'Ambiente de deploy')
        booleanParam(name: 'EXECUTAR_TESTES', defaultValue: true, description: 'Executar testes?')
        choice(name: 'LINGUAGEM', choices: ['Java', 'Python', 'NodeJS'], description: 'Selecione a linguagem')
    }

    triggers {
        cron('H/15 * * * *') // executa a cada 15 minutos
    }

    stages {
        stage('Confirmação do Usuário') {
            steps {
                script {
                    input message: "Deseja continuar com o pipeline para o ambiente ${params.AMBIENTE}?"
                }
            }
        }

        stage('Build') {
            when { not { equals expected: 'prod', actual: params.AMBIENTE } }
            steps {
                echo "Executando build para ${APP_NAME} versão ${VERSION} no ambiente ${DEPLOY_ENV}"
            }
        }

        stage('Testes') {
            when { expression { return params.EXECUTAR_TESTES } }
            steps {
                echo "Executando testes..."
            }
        }

        stage('Credenciais') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'meu-usuario-senha', usernameVariable: 'USER', passwordVariable: 'PASS')]) {
                    echo "Usuário: ${USER}"
                    echo "Senha protegida (não exibida)"
                }
            }
        }

        stage('Execução Paralela') {
            parallel {
                stage('Job 1') {
                    steps {
                        echo "Executando Job 1"
                        sleep 2
                    }
                }
                stage('Job 2') {
                    steps {
                        echo "Executando Job 2"
                        sleep 2
                    }
                }
            }
        }

        stage('Matrix de Build') {
            matrix {
                axes {
                    axis {
                        name 'OS'
                        values 'linux', 'windows'
                    }
                    axis {
                        name 'JDK'
                        values '11', '17'
                    }
                }
                stages {
                    stage('Compilação Matrix') {
                        steps {
                            echo "Compilando no SO=${OS} com JDK=${JDK}"
                        }
                    }
                }
            }
        }
    }

    post {
        always {
            echo "Pipeline finalizado"
        }
        success {
            echo "Pipeline executado com sucesso!"
        }
        failure {
            echo "Pipeline falhou!"
        }
    }
}
