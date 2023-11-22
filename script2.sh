+ any_target_group_has_healthy_targets=false
++ echo '[
    "arn:aws:elasticloadbalancing:ap-southeast-2:474623237137:targetgroup/AOAPI-IGO-Blank-uat/55a7b6f779427d45",
    "arn:aws:elasticloadbalancing:ap-southeast-2:474623237137:targetgroup/AOAPI-IGO-TG-uat/bd904f46e9a74f65"
]'
++ jq -c -r '.[]'
+ IFS=
+ read -r target_group_arn
++ aws elbv2 describe-target-health --target-group-arn $'arn:aws:elasticloadbalancing:ap-southeast-2:474623237137:targetgroup/AOAPI-IGO-Blank-uat/55a7b6f779427d45\r' --query 'TargetHealthDescriptions[?TargetHealth.State==`healthy`].length(@)' --output json --profile common-dev
