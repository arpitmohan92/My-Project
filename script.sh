module "iam_policies_npr" {
    source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
    version     = "5.33.0"
    providers   = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
        for key, value in local.iam_policies_map: key => value
        if terraform.workspace == "npr"
    }

    name        = each.value.name
    description = each.value.description
    policy      = each.value.policy
    tags        = try(merge(local.common_tags,each.value.extra_tags),local.common_tags)
}

module "iam_roles_npr" {
    source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version                 = "5.33.0"
    providers               = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
        for key, value in local.iam_roles_map: key => value
        if terraform.workspace == "npr"
    }

    role_name               = each.value.role_name
    role_requires_mfa       = false
    create_role             = true
    create_instance_profile = try (each.value.create_instance_profile, false)

    create_custom_role_trust_policy = true
    role_description         = try(each.value.role_description, null)
    custom_role_trust_policy = try(each.value.custom_trust_policy, null)

    trusted_role_services = try(each.value.trusted_role_services,[])
    trusted_role_actions  = try(each.value.trusted_role_actions,[])
    trusted_role_arns     = try(each.value.trusted_role_arns,[])
    role_sts_externalid   = try(each.value.role_sts_externalid,[])
    

    custom_role_policy_arns = concat(
        try(each.value.aws_managed_policy_attachments,[])
        # [for s in each.value.custom_role_policy_attachments : module.iam_policies_npr[0].arn]
    ) 

    tags = try(merge(local.common_tags,each.value.extra_tags),local.common_tags)
}


module "log_group" {
    source  = "terraform-aws-modules/cloudwatch/aws//modules/log-group"
    version = "~> 3.0"
    providers               = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
      for key, value in local.log_group_map_cloudwatch: key => value
      if terraform.workspace == "npr"
  }
    name = each.value.name

}

module "cloudwatch_logs_subscription" {
  source           = "gitlab.com/virginaustralia/aws-cloudwatch/local"
  version          = "1.0.14"
    providers    = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
        for key, value in local.cloudwatch_logs_map_subscription: key => value
        if terraform.workspace == "npr"
    } 
    cloudwatch_log_subscription_filter_name = each.value.name
    log_group_name = each.value.log_group_map_cloudwatch.name
    cloudwatch_role_arn = each.value.cloudwatch_role_arn

}



module "iam_policies_npr_cloudwatch" {
    source      = "terraform-aws-modules/iam/aws//modules/iam-policy"
    version     = "5.33.0"
    providers   = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
        for key, value in local.iam_policies_map_cloudwatch: key => value
        if terraform.workspace == "npr"
    }

    name        = each.value.name
    description = each.value.description
    policy      = each.value.policy
    tags        = try(merge(local.common_tags,each.value.extra_tags),local.common_tags)
}

module "iam_roles_npr_cloudwatch" {
    source                  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"
    version                 = "5.33.0"
    providers               = {aws = aws.cc-bayee-workloads-npr}
    for_each = {
        for key, value in local.iam_roles_map_cloudwatch: key => value
        if terraform.workspace == "npr"
    }

    role_name               = each.value.role_name
    role_requires_mfa       = false
    create_role             = true
    create_instance_profile = try (each.value.create_instance_profile, false)

    create_custom_role_trust_policy = true
    role_description         = try(each.value.role_description, null)
    custom_role_trust_policy = try(each.value.custom_trust_policy, null)

    trusted_role_services = try(each.value.trusted_role_services,[])
    trusted_role_actions  = try(each.value.trusted_role_actions,[])
    trusted_role_arns     = try(each.value.trusted_role_arns,[])
    role_sts_externalid   = try(each.value.role_sts_externalid,[])
    

    custom_role_policy_arns = concat(
        try(each.value.aws_managed_policy_attachments,[])
        # [for s in each.value.custom_role_policy_attachments : module.iam_policies_npr[0].arn]
    ) 

    tags = try(merge(local.common_tags,each.value.extra_tags),local.common_tags)


}
