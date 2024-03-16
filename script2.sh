apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: example-cronjob
spec:
  schedule: "*/1 * * * *"  # Schedule to run every minute
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: job-container
            image: busybox
            command: ["echo", "Hello from the CronJob"]
          restartPolicy: OnFailure
