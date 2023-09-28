resource "shoreline_notebook" "host_cpu_high_iowait_incident" {
  name       = "host_cpu_high_iowait_incident"
  data       = file("${path.module}/data/host_cpu_high_iowait_incident.json")
  depends_on = [shoreline_action.invoke_tcpdump_script,shoreline_action.invoke_iowait_disk_io_check,shoreline_action.invoke_cleanup_log_files]
}

resource "shoreline_file" "tcpdump_script" {
  name             = "tcpdump_script"
  input_file       = "${path.module}/data/tcpdump_script.sh"
  md5              = filemd5("${path.module}/data/tcpdump_script.sh")
  description      = "Check for high network utilization by process"
  destination_path = "/agent/scripts/tcpdump_script.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "iowait_disk_io_check" {
  name             = "iowait_disk_io_check"
  input_file       = "${path.module}/data/iowait_disk_io_check.sh"
  md5              = filemd5("${path.module}/data/iowait_disk_io_check.sh")
  description      = "Insufficient disk I/O throughput causing the CPU to wait for data to be read or written to the disk."
  destination_path = "/agent/scripts/iowait_disk_io_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cleanup_log_files" {
  name             = "cleanup_log_files"
  input_file       = "${path.module}/data/cleanup_log_files.sh"
  md5              = filemd5("${path.module}/data/cleanup_log_files.sh")
  description      = "Increase the available disk space by deleting unnecessary files or adding more storage capacity."
  destination_path = "/agent/scripts/cleanup_log_files.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tcpdump_script" {
  name        = "invoke_tcpdump_script"
  description = "Check for high network utilization by process"
  command     = "`chmod +x /agent/scripts/tcpdump_script.sh && /agent/scripts/tcpdump_script.sh`"
  params      = ["DURATION","PORT","INTERFACE"]
  file_deps   = ["tcpdump_script"]
  enabled     = true
  depends_on  = [shoreline_file.tcpdump_script]
}

resource "shoreline_action" "invoke_iowait_disk_io_check" {
  name        = "invoke_iowait_disk_io_check"
  description = "Insufficient disk I/O throughput causing the CPU to wait for data to be read or written to the disk."
  command     = "`chmod +x /agent/scripts/iowait_disk_io_check.sh && /agent/scripts/iowait_disk_io_check.sh`"
  params      = ["DISK_NAME"]
  file_deps   = ["iowait_disk_io_check"]
  enabled     = true
  depends_on  = [shoreline_file.iowait_disk_io_check]
}

resource "shoreline_action" "invoke_cleanup_log_files" {
  name        = "invoke_cleanup_log_files"
  description = "Increase the available disk space by deleting unnecessary files or adding more storage capacity."
  command     = "`chmod +x /agent/scripts/cleanup_log_files.sh && /agent/scripts/cleanup_log_files.sh`"
  params      = ["DAYS_MODIFIED","DIRECTORY_PATH"]
  file_deps   = ["cleanup_log_files"]
  enabled     = true
  depends_on  = [shoreline_file.cleanup_log_files]
}

