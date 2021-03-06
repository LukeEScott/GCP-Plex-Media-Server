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

## Create API Key

Navigate to [API & Services](https://console.cloud.google.com/apis/credentials?project=) and select *Create Credentials*. From the drop-drop menu select *API Key*.

![Create API Key](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-15%20at%2022.00.47.png)

You should then be presented with a dialog box showing you the API key you've just created as seen below:

![API Key Created](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-15%20at%2022.03.52.png)

Copy the key and within the variables.tf file you need to input the value into the *api-key* variable. 



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

## SSH Into VM

Now it's time to install Plex onto the newly created VM. Go to [Compute Engine](https://console.cloud.google.com/compute/instances?project=) within the GCP console and get the external IP attached to the VM. Now within your terminal run the command below to SSH into the VM

```bash
ssh <External IP>
```

After logging into the instance you should see something like below

![Logging Into VM](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2020.38.53.png)

## Changing the Timezone

By default the VM will be on UTC time but you may want to configure it to your local region. To check the timezone setting run the following command:

```bash
timedatectl
```
![Checking Timzone](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-14%20at%2015.24.13.png)

You can run the command below to see a list of the regions:

```bash
timedatectl list-timezones
```

Now run the following command to change the Timezone to your chosen preference. 

```bash
sudo timedatectl set-timezone <your_time_zone>
```

EXAMPLE:
```bash
sudo timedatectl set-timezone Europe/London
```
![BST Timezone](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-14%20at%2015.27.50.png)


## Installing Plex

Go to Plex's server [download page](https://www.plex.tv/media-server-downloads/#plex-media-server), select Linux and right click on Ubuntu (16.04+) / Debian (8+)with 32-bit or 64-bit and select *Copy Link Address'. Go back to the terminal and run the following command:

```bash
wget <URL you just copied>
```
![wget Command](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2020.59.23.png)

Run the command below to verify the Plex deb package has been downloaded.

```bash
ls
```
![ls Command](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-14%20at%2015.37.54.png)

Now it's time to install the Plex deb package by running the following command:
```bash
sudo dpkg -i plexmediaserver_1.13.5.5332-21ab172de_amd64.deb
```
The -i is short for --install. Note that when you type the following
```bash
sudo dpkg -i plex
```
You can press the tab key, which will autocomplete the filename.

Now Plex media server is installed. We can check its status with the command:
```bash
systemctl status plexmediaserver
```
As you can see, it’s running on Ubuntu 18.04 system. (Press q to take back control of terminal.)
![Plex Server Running](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2021.30.53.png)


If Plex media server isn’t running, you can start it with:
```bash
sudo systemctl start plexmediaserver
```

## Enable Plex Repository

By enabling the official Plex repo, you can update Plex on Ubuntu with apt package manager. The Plex deb package ships with a source list file. To see a list of files installed from a package, run dpkg with -L flag.

```bash
dpkg -L plexmediaserver
```

Open this file with the following command.

```bash
sudo nano /etc/apt/sources.list.d/plexmediaserver.list
```

By default, its content is commented out. Uncomment the last line. (Remove the beginning # symbol). Then save and close the file. To save a file in Nano text editor, press Ctrl+O, the press Enter to confirm. To exit, press Ctrl+X.  After that, run the following command to import Plex public key to apt package manager.

```bash
wget -q https://downloads.plex.tv/plex-keys/PlexSign.key -O - | sudo apt-key add -
```

Now update software repository index.

```bash
sudo apt update
```

## Plex Media Server Initial Setup

If you run the following command:

```bash
sudo netstat -lnpt | grep Plex
```

You can see that Plex media server is listening on 0.0.0.0:32400.

![Plex Ports](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2021.40.16.png)

The web-based management interface is available at port 32400. The first time you configure Plex, you must visit Plex via 127.0.0.1:32400/web or localhost:32400/web. 

You will need to set up a SSH tunnel by executing the following command on your local computer. Replace 12.34.56.78 with the IP address of the VM you created in GCP.

```bash
ssh 12.34.56.78 -L 8888:localhost:32400
```

Then you can access Plex web interface via the following URL.

http://localhost:8888/web

This HTTP request will be redirected to http://localhost:32400/web on the remote server through SSH tunnel. This SSH tunnel is only needed for the initial setup. After the initial setup, you can access Plex web interface via server-ip-address:32400. Replace server-ip-address with your real server IP address. Once signed in, you will be redirected to localhost:32400 to do the initial setup. On the next screen, enter a name for your Plex server. Make sure Allow me to access my media outside my home is checked. Then click Next.

![Plex Server Name](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2022.07.23.png)

We're going to setup the libraries in a later step so you can also click *Next* and then *Done*. 

Finally, we need to setup *Remote Access* for the server. Navigate to your *Account Settings* and select *Remote Access*. Simply select the option *Manually specify public port and then *RETRY*. The Plex server should now be fully accessible outside of the GCP network. 

![Setup Remote Access](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2022.36.34.png)

## Mounting a NAS Drive

FYI - you will most likely need to configure port-forwarding on your router to give your NAS drive an external facing IP address to map to the server.

Firstly, we need to install SSHFS as this is the protocol we're going to use to mount the NAS drive. You can install SSHFS by running the following command:

```bash
sudo apt-get install sshfs
```
![Install SSHFS](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-12%20at%2022.50.30.png)

Now it's time to create a mount point. First we need to get inside the *mnt* directory by running the following command:

```bash
cd /mnt
```
Then to create a new mount point run the following commands:

```bash
sudo mkdir plex-media
```

```bash
cd plex-media
```

Note that the *plex* user needs to have read and execute permission on your media directories. For example, the mount path that you just created */mnt/plex-media*, which is owned by root. Users not in group root can’t access it, so you need to run the following command to give user plex read and execute permission (you need to be in /mnt/plex-media directory).

```bash
sudo chown -R plex .
```
Now it's time to mount the NAS drive with the sshfs (this assumes your NAS drive is ssh compatible).Replace *USER* with the username on the NAS and *NAS-IP* with your real NAS IP address. You will also need to replace *NAS-DIRECTORY* with the directory you want to mount from the NAS drive. Lastly, it might ask you for a password if you've set a password on your NAS drive - simply enter the password and hit enter!

```bash
sudo -u plex sshfs <USER>@<NAS-IP>:<NAS-DIRECTORY> /mnt/plex-media
```
EXAMPLE:

```bash
sudo -u plex sshfs sshd@94.3.143.130:/mnt/HD/HD_a2/Public/plex-media /mnt/plex-media
```
![Mount NAS Drive](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-13%20at%2021.39.37.png)

To verify if the NAS drive was successfully mounted you can run the command below:

```bash
sudo -u plex df-hT
```
![Check Mount](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-13%20at%2021.44.51.png)

## Automatically Mount Drive on Start-up

The easist way to do this is to create a rc.local file and paste in the command. However, before we do so we need to create a file for the password needed to succesfully mount the drive. Make sure you're within your home directory and run the command below to create the text file. 

```bash
sudo nano password.txt
```
Now add the password to the file. Remember to save a file in Nano text editor, press Ctrl+O, the press Enter to confirm. To exit, press Ctrl+X. Run the following command below to add the password to the file.

Now let's create the *rc.local* - The */etc/rc.local* file on Ubuntu and Debian systems are used to execute commands at system startup. But there's no such file in Ubuntu 18.04 - no problem let's manually create it!

```bash
sudo nano /etc/rc.local
```
Now paste the command into the file as seen below:

```bash
#!/bin/sh -e
cat /home/<USER>/password.txt | sudo -u plex sshfs <USER>@<NAS-IP>:<NAS-DIRECTORY> /mnt/plex-media -o workaround=rename -o password_stdin
exit 0
```
Finally, to make the file executable we need to run the below command: 

```bash
sudo chmod +x /etc/rc.local
```

That's it - now when you restart your server it will automatically map the NAS drive!


## Creating Plex Libraries

Now it's time to create some libraries for our Films, TV Shows and etc. Firstly, go to your Plex account settings and navigate to the *Manage* section and select *Libraries*. From there select *Add Library* and you should be presented with the below.

![Choose Plex Library](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-13%20at%2021.52.34.png)

For example, let's setup Films! Select *Films* and click *Next* - then you need to select the option *BROWSE FOR MEDIA FOLDER* and finally select *ADD LIBRARY*.

![Select Film Directory](https://storage.googleapis.com/plex-terraform-state/GitHub-Images/Screenshot%202020-07-13%20at%2021.55.26.png)










