// Define any gloabl variables here

def projectname = "jenkins"

void getVariablesInitialised() {
    if ("origin/master".equals(env.GIT_BRANCH)) {
        environment = "production"
    } else if ("origin/dev".equals(env.GIT_BRANCH)) {
        environment = "dev"
    } else if ("origin/qa".equals(env.GIT_BRANCH)) {
        environment = "qa"
    } 
}

pipeline {
    agent any
    stages {
        stage("Prechecks") {
            when {
                anyOf {
                    expression{env.GIT_BRANCH == 'origin/master'}
                    expression{env.GIT_BRANCH == 'origin/dev'}
                    expression{env.GIT_BRANCH == 'origin/qa'}
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
                                echo "This is test"
                            """
                        }
                    }
                }

            }
        }
    }
}
