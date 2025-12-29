variable "components" {
    default = {
        catalogue = {
            rule_priority = 10
        }
        user = {
            rule_priority = 20
        }
        cart = {
            rule_priority = 11
        }
        shipping = {
            rule_priority = 12
        }
        payment = {
            rule_priority = 13
        }
        frontend = {
            rule_priority = 5
        }
    }
}