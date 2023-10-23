def projectname = "jenkins"

void getVariablesInitialised() {
    if ("master".equals(env.GIT_BRANCH)) {
        environment = "production"
    } else if ("dev".equals(env.GIT_BRANCH)) {
        environment = "dev"
    } else if ("qa".equals(env.GIT_BRANCH)) {
        environment = "qa"
    } 
}

pipeline {
    agent any
    stages {
        stage("Prechecks") {
            when {
                anyOf {
                    expression{env.GIT_BRANCH == 'master'}
                    expression{env.GIT_BRANCH == 'dev'}
                    expression{env.GIT_BRANCH == 'qa'}
                }
            }
          }
            stages {
                stage("Prep") {
                    steps {
                        script {
                            echo "Executing Prep"
                        }
                        getVariablesInitialised()
                    }
                }
                stage("Checkout") {
                    steps {
                        checkout scm
                    }
                }
                stage("Build") {
                    steps {
                        script {
                            sh """
                                env
                            """
                        }
                    }
                }
               stage("Deploy") {
                    steps {
                        script {
                            sh """
                                echo ${environment}
                            """
                        }
                    }
                }

            }
        }
    }
    post {
        always {
            echo "Cleaning workspace ${env.WORKSPACE}"
            cleanWs()
        }
   }
