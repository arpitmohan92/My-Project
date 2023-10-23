// Define any gloabl variables here

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
//    stages {
//        stage("Prechecks") {
//            when {
//                anyOf {
//                    expression{env.BRANCH_NAME == 'master'}
//                    expression{env.BRANCH_NAME == 'dev'}
//                    expression{env.BRANCH_NAME == 'qa'}
//                }
//            }
            stages {
                stage("Prep") {
                    steps {
                        script {
                            echo "Executing Prep"
                            env
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
                                echo ${environment}
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
//    }
    post {
        always {
            echo "Cleaning workspace ${env.WORKSPACE}"
            cleanWs()
        }
    }
//}
