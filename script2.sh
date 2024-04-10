AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31

Parameters:
  ClientPrefix:
    Type: String
    Description: "Insert the client name to be used as prefix"
  Environment:
    Type: String
    Description: "Insert the environment type"
  LambdaVPCId:
    Type: String
    Description: VPC id hosting the Lambda
  LambdaVPCSubnetIds:
    Type: CommaDelimitedList
    Description: List of subnets in the same VPC where you want to create the the lambda
  DomainBaseDN:
    Type: String
    Description: Ldap Base domain distiguished name to search for users
  LdapUrl:
    Type: String
    Description: LDAP IP address used to contact AD
  ServiceSamAccountName:
    Type: String
    Description: Service account email to be used to connect to LDAP
  SsmPasswordPath:
    Type: String
    Description: Path to the SSM parameter that holds the password for the SERVICE_ACCOUNT
  UseProxy:
    Type: String
    Description: "Use a http proxy to contact public services. Allowed values: true, false"
    AllowedValues: ["true", "false"]
    Default: "false"
  ProxyUrl:
    Type: String
    Description: "(Only if UseProxy = true) Proxy URL in the following format: https://proxy.example.com:8080"
    Default: ""
  UsageTimeout:
    Type: String
    Description: The time after a user logs off when WorkSpaces are automatically stopped. Configured in 60-minute intervals.
    Default: 180
  LogLevel:
    Type: String
    Description: "Verbosity used to troubleshoot. Allowed values: INFO, DEBUG"
    AllowedValues: ["INFO", "DEBUG"]
    Default: "INFO"
  CmdAdmAccounts:
    Type: String
    Description: Dictionary mapping CMD admin accounts to a comment about the account
  CmdSvcAccounts:
    Type: String
    Description: Dictionary mapping service accounts to a comment about the account
  MailService:
    Type: String
    Description: "Specify if you want to use SES as mail provider or a specific SMTP relay server. Allowed values: ses, smpt"
    AllowedValues: ["ses", "smtp"]
    Default: "ses"
  IsPrivateSmtpServer:
    Type: String
    Description: "[Only if MailService = smtp] Specify if SMTP relay server is private (not on public internet). Allowed values: true, false"
    AllowedValues: ["true", "false"]
    Default: "false"
  RetentionPeriod:
    Type: String
    Description: "Number of days a workspace is retained after that its user was removed from AD or disabled"
    Default: "7"
  DeleteAdComputerObjectAtWorkspaceTermination:
    Type: String
    Description: "If true, the AD computer object related to a workspace is deleted after the workspace is terminated. Allowed values: true, false"
    AllowedValues: ["true", "false"]
    Default: "false"
  DryRun:
    Type: String
    Description: "Execute a dry run. Allowed Values: true, false"
    AllowedValues: ["true", "false"]
    Default: "true"
  RunningMode:
    Type: String
    Description: "Workspace Running Mode"
    AllowedValues: ["AUTO_STOP", "ALWAYS_ON"]
    Default: "AUTO_STOP"
  CostOptimizerWorkspaceReportBucket:
    Type: String
    Description: Bucket created by the cost optimization solution for this environment
    Default: "*ws-cost-optimiser*"
  ExtraTags:
    Type: String
    Description: |
      Additional tags to append on each new workspace. 
      List of JSON objects. Format is [{'Key': 'k1', 'Value': 'v1'}, {'Key': 'k2', 'Value': 'v2'}]"
    Default: "[]"
  SsmClientSecretPath:
    Type: String
    Description: Path to the SSM parameter that holds the Entra client secret
  EntraClientId:
    Type: String
    Description: Entra Client ID used for reading Entra groups
  EntraTenantId:
    Type: String
    Description: Entra Tenant ID used for reading Entra groups


Conditions:
  EnvironmentExists: !Not [!Equals ["", !Ref Environment]]
  DomainBaseDNExists: !Not [!Equals ["", !Ref DomainBaseDN]]
  LdapUrlExists: !Not [!Equals ["", !Ref LdapUrl]]
  ServiceAccountExists: !Not [!Equals ["", !Ref ServiceSamAccountName]]
  SsmPasswordPathExists: !Not [!Equals ["", !Ref SsmPasswordPath]]
  RunningModeExists: !Not [!Equals ["", !Ref RunningMode]]
  UsageTimeoutExists: !Not [!Equals ["", !Ref UsageTimeout]]
  LogLevelExists: !Not [!Equals ["", !Ref LogLevel]]
  CmdAdmAccountsExists: !Not [!Equals ["", !Ref CmdAdmAccounts]]
  CmdSvcAccountsExists: !Not [!Equals ["", !Ref CmdSvcAccounts]]
  PrivateSmtpServer: !Equals ["true", !Ref IsPrivateSmtpServer]
  ProxyEnabled: !Equals ["true", !Ref UseProxy]
  SsmClientSecretPathExists: !Not [!Equals ["", !Ref SsmClientSecretPath]]
  EntraClientIdExists: !Not [!Equals ["", !Ref EntraClientId]]
  EntraTenantIdExists: !Not [!Equals ["", !Ref EntraTenantId]]

Globals:
  Function:
    Runtime: python3.11
    Timeout: 300
    MemorySize: 128
    Environment:
      Variables:
        PROXY_URL: !If [ProxyEnabled, !Ref ProxyUrl, !Ref AWS::NoValue]
        DOMAIN_BASE_DN: !If [DomainBaseDNExists, !Ref DomainBaseDN, !Ref AWS::NoValue]
        LDAP_URL: !If [LdapUrlExists, !Ref LdapUrl, !Ref AWS::NoValue]
        SERVICE_ACCOUNT: !If [ServiceAccountExists, !Ref ServiceSamAccountName, !Ref AWS::NoValue]
        SSM_PASSWORD_PATH: !If [SsmPasswordPathExists, !Ref SsmPasswordPath, !Ref AWS::NoValue]
        LOG_LEVEL: !If [LogLevelExists, !Ref LogLevel, !Ref AWS::NoValue]
        ENVIRONMENT: !Ref Environment
        SSM_CLIENT_SECRET_PATH: !If [SsmClientSecretPathExists, !Ref SsmClientSecretPath, !Ref AWS::NoValue]
        ENTRA_CLIENT_ID: !If [EntraClientIdExists, !Ref EntraClientId, !Ref AWS::NoValue]
        ENTRA_TENANT_ID: !If [EntraTenantIdExists, !Ref EntraTenantId, !Ref AWS::NoValue]
        
    Tags:
      environment: !If [EnvironmentExists, !Ref Environment, !Ref AWS::NoValue]
      repository: !Sub "${ClientPrefix}-workspaces/ws-autoprovisioner-ad"
      map-migrated: migV6F0HNKUBM

Resources:
############## FUNCTIONS ##############

  WorkspacesAdCleanSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupName: WorkspacesAdCleanSecurityGroup
      GroupDescription: 'Allow all TCP and UTP egress traffic'
      SecurityGroupEgress:
        -
          CidrIp: "0.0.0.0/0"
          FromPort: 0
          ToPort: 65535
          IpProtocol: "tcp"
        -
          CidrIp: "0.0.0.0/0"
          FromPort: 0
          ToPort: 65535
          IpProtocol: "udp"
      VpcId: !Ref LambdaVPCId

  WorkspacesLambdaGeneralPolicy:
    Type: AWS::IAM::ManagedPolicy
    Properties:
      ManagedPolicyName: WorkspacesLambdaGeneralPolicy
      PolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Action:
              - ds:Describe*
            Resource: "*"
          - Effect: Allow
            Action:
              - workspaces:TerminateWorkspaces
              - workspaces:CreateWorkspaces
              - workspaces:Describe*
              - workspaces:CreateTags
              - workspaces:DeleteTags
              - workspaces:ModifyWorkspaceProperties
            Resource: "*"
          - Effect: Allow
            Action:
              - ssm:GetParam*
              - ssm:DescribeParameters
            Resource: "*"
          - Effect: Allow
            Action:
              - kms:Describe*
              - kms:Get*
              - kms:List*
              - kms:RevokeGrant
              - kms:Encrypt
              - kms:Decrypt
              - kms:ReEncrypt*
              - kms:GenerateDataKey*
              - kms:DescribeKey
              - kms:CreateGrant
              - kms:CreateKey
              - kms:CreateAlias
              - kms:ListGrants
            Resource: "*"
          - Effect: Allow
            Action:
              - xray:PutTraceSegments
              - xray:PutTelemetryRecords
            Resource: "*"
          - Effect: Allow
            Action:
              - s3:*
            Resource:
              - Fn::Sub: "${WorkspaceReportBucket.Arn}"
              - Fn::Sub: "${WorkspaceReportBucket.Arn}/*"
              - Fn::Sub: "arn:aws:s3:::${CostOptimizerWorkspaceReportBucket}"
              - Fn::Sub: "arn:aws:s3:::${CostOptimizerWorkspaceReportBucket}/*"
    DependsOn: WorkspaceReportBucket

  WorkspacesLambdaSesPolicy:
    Type: AWS::IAM::ManagedPolicy
    Properties:
      ManagedPolicyName: WorkspacesLambdaSesPolicy
      PolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Action:
              - ses:SendEmail
              - ses:SendRawEmail
            Resource: "*"
          - Effect: Allow
            Action:
              - ssm:GetParam*
              - ssm:DescribeParameters
            Resource: "*"

  WorkspacesAdClean:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesAdClean
      Description: "Workspace Autoprovisioner - Deletes AD computer objects of terminated workspaces"
      CodeUri: workspace_ad_cleanup/
      Handler: workspace_ad_cleanup.lambda_handler
      VpcConfig:
        SecurityGroupIds:
          - !GetAtt WorkspacesAdCleanSecurityGroup.GroupId
        SubnetIds: !Ref LambdaVPCSubnetIds
      Policies:
        - !Ref WorkspacesLambdaGeneralPolicy
      Environment:
        Variables:
          DRY_RUN: !Ref DryRun

  WorkspacesCreateReport:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesCreateReport
      Description: "Workspace Autoprovisioner - Creates a set of reports"
      CodeUri: workspace_create_report/
      Handler: workspace_create_report.lambda_handler
      VpcConfig:
        SecurityGroupIds:
          - !GetAtt WorkspacesAdCleanSecurityGroup.GroupId
        SubnetIds: !Ref LambdaVPCSubnetIds
      Policies:
        - !Ref WorkspacesLambdaGeneralPolicy
        - S3WritePolicy:
            BucketName: !Ref WorkspaceReportBucket
      Environment:
        Variables:
          CMD_ADM_ACCOUNTS: !If [CmdAdmAccountsExists, !Ref CmdAdmAccounts, !Ref AWS::NoValue]
          CMD_SVC_ACCOUNTS: !If [CmdSvcAccountsExists, !Ref CmdSvcAccounts, !Ref AWS::NoValue]
          BUCKET_REPORT: !Ref WorkspaceReportBucket

  WorkspacesSendReport:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesSendReport
      Description: "Workspace Autoprovisioner - Sends the reports created by the WorkspacesCreateReport lambda"
      CodeUri: workspace_send_report/
      Handler: workspace_send_report.lambda_handler
      VpcConfig:
        !If
          - PrivateSmtpServer
          -
            SecurityGroupIds:
              - !GetAtt WorkspacesAdCleanSecurityGroup.GroupId
            SubnetIds: !Ref LambdaVPCSubnetIds
          - !Ref AWS::NoValue
      Policies:
        - !Ref WorkspacesLambdaSesPolicy
        - S3ReadPolicy:
            BucketName: !Ref WorkspaceReportBucket
      Environment:
        Variables:
          MAIL_SERVICE: !Ref MailService

  WorkspacesTerminate:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesTerminate
      Description: "Workspace Autoprovisioner - Terminate or Schedule termination date for workspaces which user is no longer in the specified AD group"
      CodeUri: workspace_terminate/
      Handler: workspace_terminate.lambda_handler
      VpcConfig:
        SecurityGroupIds:
          - !GetAtt WorkspacesAdCleanSecurityGroup.GroupId
        SubnetIds: !Ref LambdaVPCSubnetIds
      Policies:
        - !Ref WorkspacesLambdaGeneralPolicy
        - S3WritePolicy:
            BucketName: !Ref WorkspaceReportBucket
      Environment:
        Variables:
          CMD_ADM_ACCOUNTS: !If [CmdAdmAccountsExists, !Ref CmdAdmAccounts, !Ref AWS::NoValue]
          CMD_SVC_ACCOUNTS: !If [CmdSvcAccountsExists, !Ref CmdSvcAccounts, !Ref AWS::NoValue]
          DRY_RUN: !Ref DryRun
          BUCKET_REPORT: !Ref WorkspaceReportBucket
          DAYS_OF_RETENTION: !Ref RetentionPeriod
          ENABLE_DELETE_COMPUTER_OBJECTS: !Ref DeleteAdComputerObjectAtWorkspaceTermination

  WorkspacesUserSync:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesUserSync
      Description: "Workspace Autoprovisioner - Provisions workspaces for new users in the specified AD groups"
      CodeUri: workspace_user_sync/
      Handler: workspace_user_sync.lambda_handler
      Policies:
        - !Ref WorkspacesLambdaGeneralPolicy
      Environment:
        Variables:
          RUNNINGMODE: !If [RunningModeExists, !Ref RunningMode, !Ref AWS::NoValue]
          USAGETIMEOUT: !If [UsageTimeoutExists, !Ref UsageTimeout, !Ref AWS::NoValue]
          DRY_RUN: !Ref DryRun
          EXTRA_TAGS: !Ref ExtraTags

  WorkspacesPollOnCreation:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesPollOnCreation
      Description: "Workspace Autoprovisioner - Poll workspaces in creation state"
      CodeUri: workspace_poll_on_creation/
      Handler: workspace_poll_on_creation.lambda_handler
      Policies:
        - !Ref WorkspacesLambdaGeneralPolicy
      Environment:
        Variables:
          DRY_RUN: !Ref DryRun

  WorkspacesNotifyUser:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesNotifyUser
      Description: "Workspace Autoprovisioner - Send an email to the user once their workspace is created"
      CodeUri: workspace_notify_user/
      Handler: workspace_notify_user.lambda_handler
      VpcConfig:
        !If
          - PrivateSmtpServer
          -
            SecurityGroupIds:
              - !GetAtt WorkspacesAdCleanSecurityGroup.GroupId
            SubnetIds: !Ref LambdaVPCSubnetIds
          - !Ref AWS::NoValue
      Policies:
        - !Ref WorkspacesLambdaSesPolicy
      Environment:
        Variables:
          MAIL_SERVICE: !Ref MailService

  WorkspacesTaskEnd:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: WorkspacesTaskEnd
      Description: "Workspace Autoprovisioner - Raise errors if something went wrong during the workspace creation/termination process"
      CodeUri: workspace_task_end/
      Handler: workspace_task_end.lambda_handler

############## SCHEDULES ##############

  WorkspacesAdCleanSchedule:
    Type: AWS::Events::Rule
    Properties:
      Name: WorkspacesAdCleanSchedule
      ScheduleExpression: 'rate(1 day)'
      State: ENABLED
      Targets:
        - Id: WorkspacesManagerStateMachine
          Arn: !Ref WorkspacesManagerStateMachine
          RoleArn: !GetAtt StateMachineScheduleRole.Arn
          Input: >
            {
              "action": "ad_cleanup",
              "active_directory": [
                {
                  "workspaces_organizational_unit": "OU=AWS WorkSpaces,OU=UAT,OU=Windows10 20H2,OU=EndUserDevices,DC=virginblue,DC=internal",
                  "directory_ids": {
                    "d-9767411112": "Small"
                  }
                }
              ]
            }

  WorkspacesUserSyncSchedule:
    Type: AWS::Events::Rule
    Properties:
      Name: WorkspacesUserSyncSchedule
      ScheduleExpression: 'rate(5 minutes)'
      State: ENABLED
      Targets:
        - Id: WorkspacesManagerStateMachine
          Arn: !Ref WorkspacesManagerStateMachine
          RoleArn: !GetAtt StateMachineScheduleRole.Arn
          Input: >
            {
              "action": "user_sync",
              "notify_user": "true",
              "entra_directory": [{
                "group_name": "ACL-Workspace-General-Users-NPR",
                "directory_ids": {
                  "d-9767411112": "Small"
                },
                "bundle_id": "wsb-j3qld0jbt",
                "workspaces_organizational_unit": "OU=AWS WorkSpaces,OU=UAT,OU=Windows10 20H2,OU=EndUserDevices,DC=virginblue,DC=internal"
              }],
              "email": {
                "sender": "no-reply-npr@workspace.virginaustralia.com",
                "support_mail": "Service Desk"
              }
            }

  WorkspacesCreateReportSchedule:
    Type: AWS::Events::Rule
    Properties:
      Name: WorkspacesCreateReportSchedule
      ScheduleExpression: 'cron(0 23 ? * SUN *)' # At 23:00 on Sunday
      State: ENABLED
      Targets:
        - Id: WorkspacesManagerStateMachine
          Arn: !Ref WorkspacesManagerStateMachine
          RoleArn: !GetAtt StateMachineScheduleRole.Arn
          Input: !Sub >
            {
              "action": "report",
              "search_entra": true,
              "active_directory": [
                {
                  "group_name": "ACL-Workspace-General-Users-NPR",
                  "workspaces_organizational_unit": "OU=AWS WorkSpaces,OU=UAT,OU=Windows10 20H2,OU=EndUserDevices,DC=virginblue,DC=internal",
                  "directory_ids": {
                    "d-9767411112": "Small"
                  }
                }
              ],
              "email": {
                "sender": "no-reply-npr@workspace.virginaustralia.com",
                "recipients": ["vibham.sharma@virginaustralia.com", "itproduction-integratedcloud-citrix@virginaustralia.com"],
                "subject": "AWS Non-Prod Workspaces Report",
                "body": "The attached reports provide an overview of:\n\t- Workspaces provisioned\n\t- Workspaces to be deleted in next 5 days\n\t- Workspaces with no login in last 7 days\n\t- Workspaces in AutoStart vs AlwaysOn"
              },
              "report": {
                "Workspaces provisioned in last X days": {"days": "-1"},
                "Workspaces to be deleted in X days": {"days": "5"},
                "Workspaces with no login in last X days": {"days": "7"},
                "Workspaces in AutoStart vs AlwaysOn": {
                  "cost-optimiser-bucket": "${CostOptimizerWorkspaceReportBucket}"
                }
              }
            }

  WorkspacesTerminateSchedule:
    Type: AWS::Events::Rule
    Properties:
      Name: WorkspacesTerminateSchedule
      ScheduleExpression: 'cron(0 15 ? * SUN *)' # At 15:00 on Sunday
      State: ENABLED
      Targets:
        - Id: WorkspacesManagerStateMachine
          Arn: !Ref WorkspacesManagerStateMachine
          RoleArn: !GetAtt StateMachineScheduleRole.Arn
          Input: >
            {
              "action": "terminate",
              "send_report": "true",
              "entra_directory": [{
                "group_name": "ACL-Workspace-General-Users-NPR",
                "directory_ids": {
                  "d-9767411112": "Small"
                },
                "bundle_id": "wsb-j3qld0jbt",
                "workspaces_organizational_unit": "OU=AWS WorkSpaces,OU=UAT,OU=Windows10 20H2,OU=EndUserDevices,DC=virginblue,DC=internal"
              }],
              "email": {
                "recipients": ["vibham.sharma@virginaustralia.com", "itproduction-integratedcloud-citrix@virginaustralia.com"],
                "sender": "no-reply-npr@workspace.virginaustralia.com",
                "subject":  "AWS Workspace Non-Prod Terminated Report",
                "body": "This is a report of terminated WorkSpaces due to a disabled user account or the user not belonging to the aws workspaces EntraID group"
              }
            }

############## ROLES AND POLICIES ##############

  StatesExecutionRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: "Allow"
            Principal:
              Service:
                - Fn::Sub: states.${AWS::Region}.amazonaws.com
            Action: "sts:AssumeRole"
      Path: "/"
      Policies:
        - PolicyName: StatesExecutionPolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - "lambda:InvokeFunction"
                Resource: "*"

  StateMachineScheduleRole:
    Type: "AWS::IAM::Role"
    Properties:
      AssumeRolePolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Effect: "Allow"
            Principal:
              Service: events.amazonaws.com
            Action: "sts:AssumeRole"
      Path: "/"
      Policies:
        - PolicyName: StepFunctionsExecutionPolicy
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: Allow
                Action:
                  - "states:StartExecution"
                Resource: "*"

############## STATE FUNCTIONS ##############

  WorkspacesManagerStateMachine:
    Type: "AWS::StepFunctions::StateMachine"
    Properties:
      StateMachineName: WorkspaceManager
      DefinitionString:
        Fn::Sub:
          - |-
            {
              "Comment": "A state machine for creating a general workspaces report",
              "StartAt": "BeginTask",
              "States": {
                  "BeginTask":{
                      "Type": "Pass",
                      "Next": "ActionChoice"
                  },
                  "ActionChoice":{
                      "Type": "Choice",
                      "Choices": [
                          {
                            "Variable": "$.action",
                            "StringEquals": "user_sync",
                            "Next": "SyncUsers"
                          },
                          {
                            "Variable": "$.action",
                            "StringEquals": "report",
                            "Next": "CreateReport"
                          },
                          {
                            "Variable": "$.action",
                            "StringEquals": "terminate",
                            "Next": "TerminateWorkspaces"
                          },
                          {
                            "Variable": "$.action",
                            "StringEquals": "ad_cleanup",
                            "Next": "CleanupAD"
                          }
                        ]
                  },
                  "TerminateWorkspaces": {
                      "Type": "Task",
                      "Resource": "${TerminateWorkspacesArn}",
                      "Next": "SendTerminationReportChoise"
                  },
                  "SendTerminationReportChoise": {
                    "Type": "Choice",
                    "Choices": [
                        {
                          "Variable": "$.send_report",
                          "StringEquals": "true",
                          "Next": "SendReport"
                        }
                    ],
                    "Default": "EndTask"
                  },
                  "CreateReport": {
                      "Type": "Task",
                      "Resource": "${CreateReportArn}",
                      "Next": "SendReport"
                  },
                  "SendReport": {
                      "Type": "Task",
                      "Resource": "${SendReportArn}",
                      "InputPath": "$",
                      "Next": "EndTask"
                  },
                  "SyncUsers": {
                      "Type": "Task",
                      "Resource": "${SyncUsersArn}",
                      "Next": "PollNewWorkspaces"
                  },
                  "PollNewWorkspaces": {
                      "Type": "Task",
                      "Resource": "${PollNewWorkspacesArn}",
                      "Next": "NotifyUserChoise",
                      "Retry": [ {
                            "ErrorEquals": [ "WorkspaceStillInPendingException" ],
                            "IntervalSeconds": 60,
                            "BackoffRate": 1.0,
                            "MaxAttempts": 80
                         }]
                  },
                  "NotifyUserChoise": {
                    "Type": "Choice",
                    "Choices": [
                        {
                          "Variable": "$.notify_user",
                          "StringEquals": "true",
                          "Next": "NotifyUser"
                        }
                    ],
                    "Default": "EndTask"
                  },
                  "NotifyUser": {
                      "Type": "Task",
                      "Resource": "${NotifyUserArn}",
                      "Next": "EndTask"
                  },
                  "CleanupAD": {
                      "Type": "Task",
                      "Resource": "${CleanupAdArn}",
                      "Next": "EndTask"
                  },
                  "EndTask":{
                      "Type": "Task",
                      "Resource": "${TaskEndArn}",
                      "End": true
                  }
              }
            }
          - {
            TerminateWorkspacesArn: !GetAtt [WorkspacesTerminate, Arn],
            CreateReportArn: !GetAtt [WorkspacesCreateReport, Arn],
            SendReportArn: !GetAtt [WorkspacesSendReport, Arn],
            SyncUsersArn: !GetAtt [WorkspacesUserSync, Arn],
            PollNewWorkspacesArn: !GetAtt [WorkspacesPollOnCreation, Arn],
            NotifyUserArn: !GetAtt [WorkspacesNotifyUser, Arn],
            CleanupAdArn: !GetAtt [WorkspacesAdClean, Arn],
            TaskEndArn: !GetAtt [WorkspacesTaskEnd, Arn]
          }
      RoleArn: !GetAtt [ StatesExecutionRole, Arn ]

############## EXTRA RESOURCES ##############

  WorkspaceReportBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub "${ClientPrefix}-${Environment}-workspaces-report"
