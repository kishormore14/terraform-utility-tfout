locals {
  # Robust cross-platform OS detection using abspath
  is_windows = length(regexall("^[a-zA-Z]:|\\\\", abspath(path.module))) > 0

  # Construct details command line flags
  details_flags = join(" ", [
    for k, v in var.details : "--detail \"${replace(k, "\"", "\\\"")}=${replace(v, "\"", "\\\"")}\""
  ])

  # Construct items command line flags
  items_flags = join(" ", [
    for item in var.items : "--item \"${replace(item, "\"", "\\\"")}\""
  ])

  # Optional message flag
  message_flag = var.message != "" ? "--message \"${replace(var.message, "\"", "\\\"")}\"" : ""

  # Optional show sensitive flag
  sensitive_flag = var.show_sensitive ? "--show-sensitive" : ""

  # Full tfout command argument string
  banner_args = trimspace(join(" ", [
    "--title \"${replace(var.title, "\"", "\\\"")}\"",
    "--status \"${var.status}\"",
    local.message_flag,
    local.details_flags,
    local.items_flags,
    "--theme \"${var.theme}\"",
    "--border \"${var.border}\"",
    "--color \"${var.color}\"",
    local.sensitive_flag
  ]))

  # Helper script selection
  script_cmd = local.is_windows ? "powershell -ExecutionPolicy Bypass -File ${path.module}/scripts/get_tfout.ps1 -Version ${var.tfout_version}" : "bash ${path.module}/scripts/get_tfout.sh ${var.tfout_version}"
}

# Auto-resolve binary location cross-platform
data "external" "tfout_binary" {
  program = local.is_windows ? ["powershell", "-ExecutionPolicy", "Bypass", "-File", "${path.module}/scripts/get_tfout.ps1", "-Version", var.tfout_version, "-Prefix", var.download_url_prefix] : ["bash", "${path.module}/scripts/get_tfout.sh", var.tfout_version, var.download_url_prefix]
}

# Display terminal banner during terraform apply
resource "null_resource" "banner" {
  triggers = {
    title   = var.title
    status  = var.status
    message = var.message
    details = jsonencode(var.details)
    items   = jsonencode(var.items)
    theme   = var.theme
    border  = var.border
    color   = var.color
  }

  provisioner "local-exec" {
    command = "${data.external.tfout_binary.result.binary_path} banner ${local.banner_args}"
  }
}
