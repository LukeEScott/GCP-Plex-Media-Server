# Enable API's

Enable the following API's
-Compute Engine API
-Identity and Access Management (IAM) API
-Cloud Resource Manager API

# Creating the service account:

Create a service account within the project you created within GCP (Google Cloud Platform).
The service account will need 'Editor' access to the project. Download the JSON file and rename it to 'service_account.json'. Move the file into the repo directoty and then run the following command below:

#Export the service account into an environment variable

```bash
export GOOGLE_CREDENTIALS=$(cat service_account.json)
```
# Initialise Terraform

Run the following command to initlaise Terraform.

```bash
terraform init
```

# Changing the config to match your preferences

Open the variables.tf file and change the project name, zone, region to match your preferences. 


# Run Terraform

First let's run the plan command to see what terraform will execute if we were to run the apply command. 

```bash
terraform plan
```

Once you're happy with the plan, it's time to execute it by running the command 

```bash
terraplan apply
```

Now your VM instance should be created within your project. 

# SSH into your VM locally

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
It will display the public key in the terminal as shown below. Highlight and copy this key:



