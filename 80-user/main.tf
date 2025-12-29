module "user" {
    source = "git::https://github.com/vigneshkattamudi/terraform-aws-roboshop.git?ref=main"
    component = "user"
    rule_priority = 20
}