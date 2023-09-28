resource "shoreline_notebook" "host_cpu_high_iowait_incident" {
  name       = "host_cpu_high_iowait_incident"
  data       = file("${path.module}/data/host_cpu_high_iowait_incident.json")
  depends_on = [shoreline_action.invoke_tcpdump_capture,shoreline_action.invoke_iowait_disk_io_threshold_check,shoreline_action.invoke_cleanup_and_diskusage]
}

resource "shoreline_file" "tcpdump_capture" {
  name             = "tcpdump_capture"
  input_file       = "${path.module}/data/tcpdump_capture.sh"
  md5              = filemd5("${path.module}/data/tcpdump_capture.sh")
  description      = "Check for high network utilization by process"
  destination_path = "/agent/scripts/tcpdump_capture.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "iowait_disk_io_threshold_check" {
  name             = "iowait_disk_io_threshold_check"
  input_file       = "${path.module}/data/iowait_disk_io_threshold_check.sh"
  md5              = filemd5("${path.module}/data/iowait_disk_io_threshold_check.sh")
  description      = "Insufficient disk I/O throughput causing the CPU to wait for data to be read or written to the disk."
  destination_path = "/agent/scripts/iowait_disk_io_threshold_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "cleanup_and_diskusage" {
  name             = "cleanup_and_diskusage"
  input_file       = "${path.module}/data/cleanup_and_diskusage.sh"
  md5              = filemd5("${path.module}/data/cleanup_and_diskusage.sh")
  description      = "Increase the available disk space by deleting unnecessary files or adding more storage capacity."
  destination_path = "/agent/scripts/cleanup_and_diskusage.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_tcpdump_capture" {
  name        = "invoke_tcpdump_capture"
  description = "Check for high network utilization by process"
  command     = "`chmod +x /agent/scripts/tcpdump_capture.sh && /agent/scripts/tcpdump_capture.sh`"
  params      = ["PORT","DURATION","INTERFACE"]
  file_deps   = ["tcpdump_capture"]
  enabled     = true
  depends_on  = [shoreline_file.tcpdump_capture]
}

resource "shoreline_action" "invoke_iowait_disk_io_threshold_check" {
  name        = "invoke_iowait_disk_io_threshold_check"
  description = "Insufficient disk I/O throughput causing the CPU to wait for data to be read or written to the disk."
  command     = "`chmod +x /agent/scripts/iowait_disk_io_threshold_check.sh && /agent/scripts/iowait_disk_io_threshold_check.sh`"
  params      = ["DISK_NAME"]
  file_deps   = ["iowait_disk_io_threshold_check"]
  enabled     = true
  depends_on  = [shoreline_file.iowait_disk_io_threshold_check]
}

resource "shoreline_action" "invoke_cleanup_and_diskusage" {
  name        = "invoke_cleanup_and_diskusage"
  description = "Increase the available disk space by deleting unnecessary files or adding more storage capacity."
  command     = "`chmod +x /agent/scripts/cleanup_and_diskusage.sh && /agent/scripts/cleanup_and_diskusage.sh`"
  params      = ["DIRECTORY_PATH","DAYS_MODIFIED"]
  file_deps   = ["cleanup_and_diskusage"]
  enabled     = true
  depends_on  = [shoreline_file.cleanup_and_diskusage]
}

