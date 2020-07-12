# Creating Your Own Plex Media Server In GCP!

## Create a Project in GCP:

Create a GCP project and remember to take a note of the Project ID. 

![Project Creation](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-11%20at%2021.37.51.png)

## Enable API's

* [Compute Engine API](https://console.cloud.google.com/apis/api/compute.googleapis.com/overview?project=>)

* [Identity and Access Management (IAM) API](https://console.cloud.google.com/apis/api/iam.googleapis.com/overview?project=)

* [Cloud Resource Manager API](https://console.cloud.google.com/apis/api/cloudresourcemanager.googleapis.com/overview?project=)

* [Cloud Scheduler API](https://console.cloud.google.com/apis/api/cloudscheduler.googleapis.com/overview?project=)

## Create a Google Cloud Storage Bucket

Now you need to create a Google Cloud Storage Bucket for your Terraform state to be stored. 

![Creation of Bucket](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-11%20at%2022.16.24.png)

## Create the Terraform Service Account:

Create a service account within the project you created. The service account will need *Editor* & *Project IAM Admin* permissions for the project. Download the JSON file and rename it to 'service_account.json'. Finally move the file into the repo directory.

Export the service account into an environment variable within your terminal:

```bash
export GOOGLE_CREDENTIALS=$(cat service_account.json)
```

## Enable App Engine

Create an [App Engine](https://console.cloud.google.com/appengine/start?project=) application (this is required for the Cloud Scheduler to work).

![Create App Engine Application](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-10%20at%2021.45.00.png)

## Create an SSH Public Key

Mac and Linux support SSH connection natively. You just need to generate an SSH key pair (public key/private key) to connect securely to the virtual machine.

The private key is equivalent to a password. Thus, it is kept private, residing on your computer, and should not be shared with any entity. The public key is shared with the computer or server to which you want to establish the connection. To generate the SSH key pair to connect securely to the virtual machine, follow these steps:

Enter the following command in Terminal: 

```bash
ssh-keygen -t rsa
```
It will start the key generation process. You will be prompted to choose the location to store the SSH key pair. Press ENTER to accept the default location as shown below:


Next, choose a password for your login to the virtual machine or hit ENTER if you wish not to use a password. The private key (i.e. identification) and the public key will be generated as shown below:


Now run the following command: 

```bash
cat ~/.ssh/id_rsa.pub
```
It will display the public key within the terminal - highlight and copy this key. Create a text file called *ssh-keys.txt* and paste the contents of the key. Finally move the file into the repo directory.


## Initialise Terraform

Run the following command to initlaise Terraform.

```bash
terraform init
```


## Change the config to match your preferences

Open the variables.tf file and change the project, zone, region and name to match your preferences. For example, you will need to change the project default value to your Project ID.  

Open the main.tf file and change the bucket name under the Terraform backend section as seen below.

![Change Terraform Backend](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-11%20at%2022.24.59.png)


## Run Terraform

First let's run the plan command to see what terraform will execute if we were to run the apply command. 

```bash
terraform plan
```

Once you're happy with the plan, it's time to execute it by running the command 

```bash
terraform apply
```

This should create 10 different resources. These include a Linux VM, External IP, Firewall Rules, Service Account with Roles, Cloud Scheduler Jobs and etc. 




