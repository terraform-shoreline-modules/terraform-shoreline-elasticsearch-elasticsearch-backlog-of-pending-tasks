
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Elasticsearch Backlog of Pending Tasks
---

This incident type occurs when there is a backlog of pending tasks in Elasticsearch. Elasticsearch is a search engine that handles large amounts of data and performs various tasks, such as indexing and searching. When there is a backlog of tasks, it means that the system is not able to process requests in a timely manner, which can lead to performance issues and data inconsistencies. This can happen due to various reasons, such as hardware or network issues, software bugs, or heavy traffic on the system.

### Parameters
```shell
export ELASTICSEARCH_URL="PLACEHOLDER"

export ELASTICSEARCH_LOG_FILE_PATH="PLACEHOLDER"

export ELASTICSEARCH_DATA_DIRECTORY="PLACEHOLDER"

export NEW_MEMORY_IN_GB="PLACEHOLDER"

export ELASTICSEARCH_CLUSTER_NAME="PLACEHOLDER"

export NEW_DISK_SPACE_IN_GB="PLACEHOLDER"

export NODE_COUNT="PLACEHOLDER"
```

## Debug

### Check Elasticsearch cluster health status
```shell
curl -X GET ${ELASTICSEARCH_URL}/_cluster/health
```

### Check Elasticsearch cluster state
```shell
curl -X GET ${ELASTICSEARCH_URL}/_cluster/state
```

### Check Elasticsearch node stats
```shell
curl -X GET ${ELASTICSEARCH_URL}/_nodes/stats
```

### Check Elasticsearch pending tasks
```shell
curl -X GET ${ELASTICSEARCH_URL}/_cluster/pending_tasks
```

### Check Elasticsearch task management API
```shell
curl -X GET ${ELASTICSEARCH_URL}/_tasks?detailed=true
```

### Check Elasticsearch logs for errors or warnings
```shell
sudo grep -i "error\|warning" ${ELASTICSEARCH_LOG_FILE_PATH}
```

### Check Elasticsearch disk usage
```shell
df -h ${ELASTICSEARCH_DATA_DIRECTORY}
```

### Check Elasticsearch memory usage
```shell
ps -ef | grep elasticsearch | grep -v grep | awk '{print $2}' | xargs pmap | grep total
```

## Repair

### Increase the hardware resources of the Elasticsearch cluster to handle the load and reduce the backlog. This can involve adding more nodes to the cluster, increasing the amount of memory or disk space available, or optimizing the network configuration.
```shell
bash

#!/bin/bash



# Define the Elasticsearch cluster name and node count

CLUSTER_NAME=${ELASTICSEARCH_CLUSTER_NAME}

NODE_COUNT=${NODE_COUNT}



# Define the new hardware specifications for each node

MEMORY=${NEW_MEMORY_IN_GB}

DISK_SPACE=${NEW_DISK_SPACE_IN_GB}



# Install the necessary packages and dependencies

sudo apt-get update

sudo apt-get install -y openjdk-8-jdk



# Download and install Elasticsearch

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update

sudo apt-get install -y elasticsearch



# Configure Elasticsearch settings

sudo sed -i 's/#cluster.name: my-application/cluster.name: $CLUSTER_NAME/' /etc/elasticsearch/elasticsearch.yml

sudo sed -i 's/#node.name: node-1/node.name: ${HOSTNAME}/' /etc/elasticsearch/elasticsearch.yml

sudo sed -i 's/-Xms1g/-Xms${MEMORY}g/' /etc/elasticsearch/jvm.options

sudo sed -i 's/-Xmx1g/-Xmx${MEMORY}g/' /etc/elasticsearch/jvm.options



# Increase the number of Elasticsearch nodes

sudo sed -i 's/#node.max_local_storage_nodes: 1/node.max_local_storage_nodes: $NODE_COUNT/' /etc/elasticsearch/elasticsearch.yml



# Increase the disk space available for Elasticsearch data

sudo sed -i 's/-Xms${MEMORY}g/-Xms${MEMORY}g\n-Des.path.data: \/data\/elasticsearch/' /etc/elasticsearch/jvm.options

sudo mkdir -p /data/elasticsearch

sudo chown -R elasticsearch:elasticsearch /data/elasticsearch



# Restart Elasticsearch service

sudo systemctl daemon-reload

sudo systemctl restart elasticsearch


```