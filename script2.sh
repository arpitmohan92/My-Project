import jenkins.model.Jenkins

def isCLIDisabled() {
    // Get the Jenkins instance
    def jenkins = Jenkins.instance

    // Check if the CLI is disabled
    return jenkins.isCLIOffline()
}

// Example usage
def cliDisabled = isCLIDisabled()
println "Jenkins CLI is " + (cliDisabled ? "disabled" : "enabled")
