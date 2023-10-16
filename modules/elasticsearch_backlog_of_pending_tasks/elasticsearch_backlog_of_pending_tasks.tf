resource "shoreline_notebook" "elasticsearch_backlog_of_pending_tasks" {
  name       = "elasticsearch_backlog_of_pending_tasks"
  data       = file("${path.module}/data/elasticsearch_backlog_of_pending_tasks.json")
  depends_on = [shoreline_action.invoke_setup_elasticsearch]
}

resource "shoreline_file" "setup_elasticsearch" {
  name             = "setup_elasticsearch"
  input_file       = "${path.module}/data/setup_elasticsearch.sh"
  md5              = filemd5("${path.module}/data/setup_elasticsearch.sh")
  description      = "Increase the hardware resources of the Elasticsearch cluster to handle the load and reduce the backlog. This can involve adding more nodes to the cluster, increasing the amount of memory or disk space available, or optimizing the network configuration."
  destination_path = "/tmp/setup_elasticsearch.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_setup_elasticsearch" {
  name        = "invoke_setup_elasticsearch"
  description = "Increase the hardware resources of the Elasticsearch cluster to handle the load and reduce the backlog. This can involve adding more nodes to the cluster, increasing the amount of memory or disk space available, or optimizing the network configuration."
  command     = "`chmod +x /tmp/setup_elasticsearch.sh && /tmp/setup_elasticsearch.sh`"
  params      = ["NODE_COUNT","ELASTICSEARCH_CLUSTER_NAME","NEW_MEMORY_IN_GB","NEW_DISK_SPACE_IN_GB"]
  file_deps   = ["setup_elasticsearch"]
  enabled     = true
  depends_on  = [shoreline_file.setup_elasticsearch]
}

