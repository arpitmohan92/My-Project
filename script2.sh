    - set_fact:
        application_version: "{% if dev_deploy_snapshot == true %}"{{ app_version }}"-SNAPSHOT{% else %}{{ app_version }}{% endif %}"
