output "binary_path" {
  value       = data.external.tfout_binary.result.binary_path
  description = "Path to the resolved tfout binary executable."
}

output "banner_command" {
  value       = "${data.external.tfout_binary.result.binary_path} banner ${local.banner_args}"
  description = "The exact CLI command executed to render the terminal banner."
}
