## Running the script
```bash
cd hadoop_docker_setup
chmod +x *
./install_hadoop.sh
```
## Set Hadoop Environment Variables:

After opening the Hadoop bash shell, paste these commands:
```bash
export HADOOP_HOME=/usr/local/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
```
## Accessing Web Interfaces:

Visit the NameNode Web UI: http://localhost:50070

Visit the Resource Manager Web UI: http://localhost:8088

## Setup Script to Start Hadoop (Optional):

To make the start-hadoop script executable and move it to /usr/local/bin/, run:
```bash
sudo chmod +x start-hadoop && sudo cp start-hadoop /usr/local/bin/
```
## Starting Hadoop:

Use the start-hadoop command to start Hadoop next time you want to run it (if you set up the script).

Else, you have to enter:
```bash
sudo docker run -it -p 50070:50070 -p 8088:8088 sequenceiq/hadoop-docker:2.7.1 /etc/bootstrap.sh -bash
```
## Checking Docker Sessions:

To view all running Docker containers, use:

sudo docker ps

To view all containers (including stopped ones), use:
```bash
sudo docker ps -a
```
## Reconnecting to a Previous Docker Session:

To reconnect to a running Hadoop container (replace "container_name" with the actual name, e.g., serene_wilson):
```bash
sudo docker exec -it container_name /bin/bash
```
If the container is stopped, start it first:
```bash
sudo docker start container_name
sudo docker exec -it container_name /bin/bash
```
## Renaming a Docker Container:

To rename a Docker container, use the following command:
```bash
sudo docker rename old_container_name new_container_name
```
Example: Renaming "serene_wilson" to "hadoop_container":
```bash
sudo docker rename serene_wilson hadoop_container
```
After renaming, use the new container name for commands.

## Uploading a File from Local to Docker Container:

To copy a file from your local machine to a running Docker container, use:
```bash
sudo docker cp /path/to/your/local/file container_name:/path/in/container
```
Example: Copying "data.txt" to the "/home/hadoop" directory inside the Hadoop container:
```bash
sudo docker cp /home/akshay/data.txt container_name:/home/hadoop
```
After uploading, you can place the file into Hadoop HDFS:
```bash
sudo docker exec -it container_name hadoop fs -put /home/hadoop/data.txt /path/in/hdfs
```