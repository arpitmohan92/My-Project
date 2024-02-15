import hudson.cli.CLIMethod

def cliEnabled = false

try {
  // Attempt to get an instance of the CLIMethod class
  def cliMethod = CLIMethod.instance()
  cliEnabled = true
} catch (Exception e) {
  println "Error: CLI might be disabled. Exception: ${e}"
}

if (cliEnabled) {
  println "CLI is enabled."
} else {
  println "CLI is disabled."
}
able tomcat"
      ]
    }
  ]
}
