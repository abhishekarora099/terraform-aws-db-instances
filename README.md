This module can be used to create ec2 instances that are best for databases in the aws cloud

To use this module, add below code to your terraform code:
```
module "db-instances" {
source = "abhishekarora099/db-instances"
dbport = 3307
typeofinstance = "t2.micro"
}
```
