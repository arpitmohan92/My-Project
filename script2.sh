def jenkins = Jenkins.getInstance()
def plugin = jenkins.pluginManager.getPlugin("jenkins-cli")

if (plugin != null && plugin.enabled) {
  println "CLI plugin is enabled, suggesting CLI might be enabled."
} else {
  println "CLI plugin is either not installed or disabled, suggesting CLI might be disabled."
}
