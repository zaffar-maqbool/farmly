### Installation 
```bash
Last project
https://www.youtube.com/watch?v=Eu-FMqPg-y4&t=1s
GITHUB
AWS
JENKINS
DOCKER 

UPGRADES
Docker Compose 
Slack 
sonarscanner

IF you want to use the sh file
Make install.sh file Executable
chmod +x install.sh
sudo ./install.sh
few more to do

#Installation of Java

sudo apt update
sudo apt install fontconfig openjdk-17-jre
java -version
openjdk version "17.0.8" 2023-07-18
OpenJDK Runtime Environment (build 17.0.8+7-Debian-1deb12u1)
OpenJDK 64-Bit Server VM (build 17.0.8+7-Debian-1deb12u1, mixed mode, sharing)


Installation of Jenkins

sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins

Start Jenkins

You can enable the Jenkins service to start at boot with the command:
  sudo systemctl enable jenkins

You can start the Jenkins service with the command:
  sudo systemctl start jenkins

You can check the status of the Jenkins service using the command:
  sudo systemctl status jenkins

If everything has been set up correctly, you should see an output like this:
Loaded: loaded (/lib/systemd/system/jenkins.service; enabled; vendor preset: enabled)
Active: active (running) since Tue 2018-11-13 16:19:01 +03; 4min 57s ago


Install Docker Engine on Ubuntu

1. Set up Docker's apt repository.
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

2. Install the Docker packages.
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

3. Verify that the Docker Engine installation is successful by running the hello-world image.
sudo docker run hello-world

Add Jenkins User to Docker Group
sudo usermod -aG docker jenkins
Then restart the Jenkins service:
sudo systemctl restart jenkins
Adjust Docker Socket Permissions
sudo chmod 666 /var/run/docker.sock
Verify Docker Installation and Permissions
sudo su - jenkins
docker ps

Install Plugins like JDK, Sonarqube Scanner
Install Plugin
Go to Manage Jenkins →Plugins → Available Plugins → Install below plugins
SonarQube Scanner
Sonar Quality Gates
Slack Notification
Docker
Docker Pipeline
Eclipse Temurin installer

Installing Sonarque
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

Create a Job
Grab the Public IP Address of your EC2 Instance, Sonarqube works on Port 9000, so :9000.
Goto your Sonarqube Server.
Click on Administration → Security → Users → Click on Tokens and Update Token → Give it a name → and click on Generate Token
copy Token
Goto Jenkins Dashboard → Manage Jenkins → Credentials → Add Secret Text. It should look like this
Now, go to Dashboard → Manage Jenkins → System and Add like the below image.
Click on Apply and Save
The Configure System option is used in Jenkins to configure different server
Global Tool Configuration is used to configure different tools that we install using Plugins
We will install a sonar scanner in the tools.
In the Sonarqube Dashboard add a quality gate also
Administration → Configuration →Webhooks

Setting up Slack Incoming Webhooks
In your Slack workspace, navigate to the Apps section.
Search for “Incoming Webhooks” and install the app.
Create a new incoming webhook for the channel where you want to receive Jenkins notifications.
Copy the generated webhook URL for later use.
Configuring Jenkins for Slack Integration
Now that we have the webhook URL, let’s configure Jenkins to send notifications to Slack:
Integrate Jenkins ci in slack and use those credentials in your jenkins Global credentials (unrestricted) Also in  system config (slack )

Install Slack Plugin:
Go to your Jenkins dashboard.
Click on “Manage Jenkins” in the left sidebar.
Select “Manage Plugins.”
Navigate to the “Available” tab, search for “Slack Notification Plugin,” and install it.
In the Jenkins dashboard, go to “Manage Jenkins” > “Manage Credentials.”
Click on “Global credentials (unrestricted)” and then “Add Credentials.”
Choose “Secret text” as the kind, enter your Jenkins ci in the “Secret” field, and give it an ID (e.g., `slack-webhook`).
Click “OK” to save the credentials.

Configure Jenkins Global Settings:
Go to “Manage Jenkins” > “Configure System.”
Scroll down to the “Slack” section.
Add your Slack workspace domain in the “Team Domain” field.
Under “Integration Token,” choose the credential you created (e.g., slack-webhook) from the dropdown.
Click “Save” at the bottom of the page


