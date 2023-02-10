# project-1
First Project
In the main.tf file we have the following:

1. Created two users Keerti and Ibrahim in Azure. force_password_change = "true" for Ibrahim. It will force the user to change the password when he logins.
2. Created 4 different users in AWS using 'for_each'. The names are assigned using a variable 'users'. The variable is declared in the variable.tf file.
3. Created 2 S3 buckets using count. Bucket name is assigned dynamically  "bucket - ${count.index}". Count is assigned using a variable number_of_bucket which is declared with a default value of 2 in variable.tf. Also assgined a tag (environmnet = "Prod") to the two buckets.
4. Created a resource group with location assigned using a variable 'location'. Resource group also have a tag (environment = "Dev".
5. Created a linux virtual machine. The required fields for linux virtual machine are:
   1. name 
   2. resource_group_name
   3. location
   4. size
   5. admin_username
   6. network_interface_ids: For network interface ids, we need subnet and virtual network which are also defined as separate resources in resource blocks.
   7. ssh_key or admin_password: Here we used ssh key
   8. os_disk
   9. source_image_reference / source_image_id: Here we used source_image_reference
   Tag for virtual machine is: name="linux virtual machine"
6. Created azure storage account and provided tags name= "sa" and environment="Dev"

In the providers.tf file we have two providers aws and azure
In the output.tf file we are getting output of:
1. resource group id
2. virtual machine id
