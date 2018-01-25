This is a repository of the example code used in my presentation at [Cornell's SD-SIG](https://confluence.cornell.edu/display/CUSDSIG/2018-01-25). There's two terraform projects in ./src/:

### ec2_example
A simple SSH key, EC2 instance, secondary volume, and accompanying security group example that was used as the in-presentation demo.

### ecs_example
A slightly more complicated example that builds an ASG and ECS cluster, along with associated log groups, load balancer, notifications, etc. Not production ready (no alarms, etc), but useful has a jumping-off point. See the README in the ./src/ecs_example/ directory for more info.

### Links
A few useful links of best practices, blog posts, etc.

Terraform Module Repository, the "official" list of community modules:  
https://registry.terraform.io

A good rundown of some practices and snippets:  
https://github.com/BWITS/terraform-best-practices

Gruntworks' "Comprehensive Guide to Terraform" (now also a book):  
https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca
