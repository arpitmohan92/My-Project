{
  "kind": "CronJob",
  "apiVersion": "batch/v1",
  "metadata": {
    "name": "cronjob-qms-polling-consumer-prd-job-1",
    "namespace": "crewmgmt-prd",
    "uid": "e9afa846-6cb5-4907-b0fd-c1b0bb39fa76",
    "resourceVersion": "230293429",
    "generation": 3,
    "creationTimestamp": "2024-01-31T00:06:25Z",
    "labels": {
      "app.kubernetes.io/instance": "cc-cronjob",
      "app.kubernetes.io/managed-by": "Helm",
      "app.kubernetes.io/name": "qms-polling-consumer-prd",
      "helm.sh/chart": "cc-cronjob-1.2.1",
      "pipeline_id": "1165669446",
      "service_application": "crewmgmt",
      "service_application_type": "cronjob",
      "service_application_version": "qms-1.0.3",
      "service_component": "qms",
      "service_domain": "ao",
      "service_env": "prd",
      "service_image_tag": "v1.0.3",
      "service_min_replicas": "1",
      "service_name": "qms-polling-consumer",
      "service_owner": "Simon.Ward"
    },
    "annotations": {
      "meta.helm.sh/release-name": "qms-polling-consumer",
      "meta.helm.sh/release-namespace": "crewmgmt-prd"
    },
    "managedFields": [
      {
        "manager": "helm",
        "operation": "Update",
        "apiVersion": "batch/v1",
        "time": "2024-02-06T03:36:59Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:metadata": {
            "f:annotations": {
              ".": {},
              "f:meta.helm.sh/release-name": {},
              "f:meta.helm.sh/release-namespace": {}
            },
            "f:labels": {
              ".": {},
              "f:app.kubernetes.io/instance": {},
              "f:app.kubernetes.io/managed-by": {},
              "f:app.kubernetes.io/name": {},
              "f:helm.sh/chart": {},
              "f:pipeline_id": {},
              "f:service_application": {},
              "f:service_application_type": {},
              "f:service_application_version": {},
              "f:service_component": {},
              "f:service_domain": {},
              "f:service_env": {},
              "f:service_image_tag": {},
              "f:service_min_replicas": {},
              "f:service_name": {},
              "f:service_owner": {}
            }
          },
          "f:spec": {
            "f:concurrencyPolicy": {},
            "f:failedJobsHistoryLimit": {},
            "f:jobTemplate": {
              "f:spec": {
                "f:template": {
                  "f:metadata": {
                    "f:annotations": {
                      ".": {},
                      "f:releaseTime": {}
                    },
                    "f:labels": {
                      ".": {},
                      "f:app.kubernetes.io/instance": {},
                      "f:app.kubernetes.io/managed-by": {},
                      "f:app.kubernetes.io/name": {},
                      "f:helm.sh/chart": {},
                      "f:pipeline_id": {},
                      "f:service_application": {},
                      "f:service_application_type": {},
                      "f:service_application_version": {},
                      "f:service_component": {},
                      "f:service_domain": {},
                      "f:service_env": {},
                      "f:service_image_tag": {},
                      "f:service_min_replicas": {},
                      "f:service_name": {},
                      "f:service_owner": {}
                    }
                  },
                  "f:spec": {
                    "f:containers": {
                      "k:{\"name\":\"qms-polling-consumer-job-1\"}": {
                        ".": {},
                        "f:env": {
                          ".": {},
                          "k:{\"name\":\"NEW_RELIC_LICENSE_KEY\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"PELESYS_API_HOSTNAME\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"PELESYS_API_LOGIN\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"PELESYS_API_PASSWORD\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"SPRING_DATASOURCE_PASSWORD\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"SPRING_DATASOURCE_URL\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          },
                          "k:{\"name\":\"SPRING_DATASOURCE_USERNAME\"}": {
                            ".": {},
                            "f:name": {},
                            "f:valueFrom": {
                              ".": {},
                              "f:secretKeyRef": {}
                            }
                          }
                        },
                        "f:envFrom": {},
                        "f:image": {},
                        "f:imagePullPolicy": {},
                        "f:name": {},
                        "f:ports": {
                          ".": {},
                          "k:{\"containerPort\":8080,\"protocol\":\"TCP\"}": {
                            ".": {},
                            "f:containerPort": {},
                            "f:name": {},
                            "f:protocol": {}
                          }
                        },
                        "f:resources": {
                          ".": {},
                          "f:limits": {
                            ".": {},
                            "f:cpu": {},
                            "f:memory": {}
                          },
                          "f:requests": {
                            ".": {},
                            "f:cpu": {},
                            "f:memory": {}
                          }
                        },
                        "f:securityContext": {
                          ".": {},
                          "f:allowPrivilegeEscalation": {},
                          "f:capabilities": {
                            ".": {},
                            "f:drop": {}
                          },
                          "f:readOnlyRootFilesystem": {},
                          "f:runAsNonRoot": {}
                        },
                        "f:terminationMessagePath": {},
                        "f:terminationMessagePolicy": {}
                      }
                    },
                    "f:dnsPolicy": {},
                    "f:nodeSelector": {},
                    "f:restartPolicy": {},
                    "f:schedulerName": {},
                    "f:securityContext": {},
                    "f:serviceAccount": {},
                    "f:serviceAccountName": {},
                    "f:terminationGracePeriodSeconds": {}
                  }
                },
                "f:ttlSecondsAfterFinished": {}
              }
            },
            "f:schedule": {},
            "f:successfulJobsHistoryLimit": {},
            "f:suspend": {},
            "f:timeZone": {}
          }
        }
      },
      {
        "manager": "kube-controller-manager",
        "operation": "Update",
        "apiVersion": "batch/v1",
        "time": "2024-03-14T19:02:03Z",
        "fieldsType": "FieldsV1",
        "fieldsV1": {
          "f:status": {
            "f:lastScheduleTime": {},
            "f:lastSuccessfulTime": {}
          }
        },
        "subresource": "status"
      }
    ]
  },
  "spec": {
    "schedule": "0 05 * * *",
    "timeZone": "Australia/Brisbane",
    "concurrencyPolicy": "Forbid",
    "suspend": false,
    "jobTemplate": {
      "metadata": {
        "creationTimestamp": null
      },
      "spec": {
        "template": {
          "metadata": {
            "creationTimestamp": null,
            "labels": {
              "app.kubernetes.io/instance": "cc-cronjob",
              "app.kubernetes.io/managed-by": "Helm",
              "app.kubernetes.io/name": "qms-polling-consumer-prd",
              "helm.sh/chart": "cc-cronjob-1.2.1",
              "pipeline_id": "1165669446",
              "service_application": "crewmgmt",
              "service_application_type": "cronjob",
              "service_application_version": "qms-1.0.3",
              "service_component": "qms",
              "service_domain": "ao",
              "service_env": "prd",
              "service_image_tag": "v1.0.3",
              "service_min_replicas": "1",
              "service_name": "qms-polling-consumer",
              "service_owner": "Simon.Ward"
            },
            "annotations": {
              "releaseTime": "2024-02-06 03:36:58Z"
            }
          },
          "spec": {
            "containers": [
              {
                "name": "qms-polling-consumer-job-1",
                "image": "534368336536.dkr.ecr.ap-southeast-2.amazonaws.com/ao/crewmgmt/qms-polling-consumer:v1.0.3",
                "ports": [
                  {
                    "name": "http",
                    "containerPort": 8080,
                    "protocol": "TCP"
                  }
                ],
                "envFrom": [
                  {
                    "configMapRef": {
                      "name": "app-configmap-qms-polling-consumer"
                    }
                  }
                ],
                "env": [
                  {
                    "name": "NEW_RELIC_LICENSE_KEY",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "NEW_RELIC_LICENSE_KEY"
                      }
                    }
                  },
                  {
                    "name": "SPRING_DATASOURCE_URL",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "SPRING_DATASOURCE_URL"
                      }
                    }
                  },
                  {
                    "name": "SPRING_DATASOURCE_USERNAME",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "SPRING_DATASOURCE_USERNAME"
                      }
                    }
                  },
                  {
                    "name": "SPRING_DATASOURCE_PASSWORD",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "SPRING_DATASOURCE_PASSWORD"
                      }
                    }
                  },
                  {
                    "name": "PELESYS_API_HOSTNAME",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "PELESYS_API_HOSTNAME"
                      }
                    }
                  },
                  {
                    "name": "PELESYS_API_LOGIN",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "PELESYS_API_LOGIN"
                      }
                    }
                  },
                  {
                    "name": "PELESYS_API_PASSWORD",
                    "valueFrom": {
                      "secretKeyRef": {
                        "name": "external-secret-qms-polling-consumer-prd",
                        "key": "PELESYS_API_PASSWORD"
                      }
                    }
                  }
                ],
                "resources": {
                  "limits": {
                    "cpu": "1",
                    "memory": "4Gi"
                  },
                  "requests": {
                    "cpu": "1",
                    "memory": "4Gi"
                  }
                },
                "terminationMessagePath": "/dev/termination-log",
                "terminationMessagePolicy": "File",
                "imagePullPolicy": "Always",
                "securityContext": {
                  "capabilities": {
                    "drop": [
                      "ALL"
                    ]
                  },
                  "runAsNonRoot": false,
                  "readOnlyRootFilesystem": false,
                  "allowPrivilegeEscalation": false
                }
              }
            ],
            "restartPolicy": "Never",
            "terminationGracePeriodSeconds": 30,
            "dnsPolicy": "ClusterFirst",
            "nodeSelector": {
              "provisioner": "singleton",
              "type": "karpenter"
            },
            "serviceAccountName": "crewmgmt-prd-sa",
            "serviceAccount": "crewmgmt-prd-sa",
            "securityContext": {},
            "schedulerName": "default-scheduler"
          }
        },
        "ttlSecondsAfterFinished": 172800
      }
    },
    "successfulJobsHistoryLimit": 3,
    "failedJobsHistoryLimit": 3
  },
  "status": {
    "lastScheduleTime": "2024-03-14T19:00:00Z",
    "lastSuccessfulTime": "2024-03-14T19:02:03Z"
  }
}
