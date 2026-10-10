variable "title" {
  type        = string
  description = "Title text for the terminal banner."
}

variable "status" {
  type        = string
  default     = "info"
  description = "Status level determining banner color and badge: success, warning, error, or info."

  validation {
    condition     = contains(["success", "warning", "error", "info"], lower(var.status))
    error_message = "Status must be one of: success, warning, error, info."
  }
}

variable "message" {
  type        = string
  default     = ""
  description = "Optional body description or status message."
}

variable "details" {
  type        = map(string)
  default     = {}
  description = "Map of key-value details to display in the banner."
}

variable "items" {
  type        = list(string)
  default     = []
  description = "List of bullet point items to display in the banner."
}

variable "theme" {
  type        = string
  default     = "default"
  description = "Visual theme style: default, minimal, or mono."

  validation {
    condition     = contains(["default", "minimal", "mono"], lower(var.theme))
    error_message = "Theme must be one of: default, minimal, mono."
  }
}

variable "border" {
  type        = string
  default     = "single"
  description = "Box border style: single, double, or none."

  validation {
    condition     = contains(["single", "double", "none"], lower(var.border))
    error_message = "Border must be one of: single, double, none."
  }
}

variable "color" {
  type        = string
  default     = "auto"
  description = "Color mode: auto, always, or never."

  validation {
    condition     = contains(["auto", "always", "never"], lower(var.color))
    error_message = "Color must be one of: auto, always, never."
  }
}

variable "show_sensitive" {
  type        = bool
  default     = false
  description = "Set to true to reveal sensitive values with a security warning badge."
}

variable "tfout_version" {
  type        = string
  default     = "v0.1.4"
  description = "Version of pre-compiled tfout release binary to download automatically if not found."
}

variable "download_url_prefix" {
  type        = string
  default     = "https://github.com/kishormore14/tfout/releases/download"
  description = "GitHub Releases URL prefix to download pre-compiled tfout binaries."
}
