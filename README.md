# `tfout` Terminal Banner Terraform Module

A reusable, zero-dependency **Terraform Module** to print clean, professional terminal status banners post-apply directly in your Terraform execution workflow.

[![Terraform Registry](https://img.shields.io/badge/Terraform-Registry-623CE4.svg)](https://registry.terraform.io)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](LICENSE)

---

## Features

- 🚀 **Zero Dependency**: Users do **NOT** need Go, Python, Node.js, or manual binary installation.
- ⚡ **Auto-Binary Downloader**: Automatically resolves host OS (Windows, Linux, macOS) and architecture (`amd64`/`arm64`), fetching pre-compiled `tfout` binaries directly from release artifacts.
- 🎨 **Status Banners**: Formats titles, badges (`SUCCESS`, `WARNING`, `ERROR`, `INFO`), messages, key-value details, and bullet points.
- 🔒 **Sensitive Data Safe**: Supports security redaction standards.
- 🛠️ **Terraform Registry Ready**: Can be published to registry.terraform.io for organization-wide or community reuse.

---

## Usage Example

Add the module to any Terraform configuration:

```hcl
module "dns_banner" {
  source  = "kishormore14/tfout/utility"
  version = "0.1.7"

  title   = "ROUTE53 HOSTED ZONE CREATED"
  status  = "success"
  message = "DNS zone active and name servers ready."

  details = {
    "Domain Name"  = aws_route53_zone.primary.name
    "Name Servers" = join(", ", aws_route53_zone.primary.name_servers)
  }

  items = [
    "DNSSEC validation configured",
    "Health check monitoring attached"
  ]

  theme  = "default"
  border = "single"
  color  = "always"
}
```

### Output in Terminal on `terraform apply`:

```text
┌────────────────────────────────────────────────────────────────────────────┐
│  ✔ SUCCESS  ROUTE53 HOSTED ZONE CREATED                                    │
├────────────────────────────────────────────────────────────────────────────┤
│ DNS zone active and name servers ready.                                    │
├────────────────────────────────────────────────────────────────────────────┤
│ Domain Name:   example.com                                                 │
│ Name Servers:  ns-101.awsdns-12.com, ns-202.awsdns-25.net                  │
├────────────────────────────────────────────────────────────────────────────┤
│ • DNSSEC validation configured                                             │
│ • Health check monitoring attached                                         │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## Requirements

| Name | Version |
| :--- | :--- |
| **Terraform** | `>= 1.0.0` |
| **null provider** | `>= 3.0.0` |
| **external provider** | `>= 2.0.0` |

---

## Inputs

| Name | Description | Type | Default | Required |
| :--- | :--- | :--- | :--- | :---: |
| `title` | Title text for the terminal banner | `string` | n/a | **yes** |
| `status` | Status level badge: `success`, `warning`, `error`, `info` | `string` | `"info"` | no |
| `message` | Body message or summary | `string` | `""` | no |
| `details` | Key-value mapping of infrastructure parameters | `map(string)` | `{}` | no |
| `items` | List of bullet point strings | `list(string)` | `[]` | no |
| `theme` | Visual theme: `default`, `minimal`, `mono` | `string` | `"default"` | no |
| `border` | Box border style: `single`, `double`, `none` | `string` | `"single"` | no |
| `color` | Color mode: `auto`, `always`, `never` | `string` | `"auto"` | no |
| `show_sensitive` | Reveal sensitive values in output | `bool` | `false` | no |
| `tfout_version` | Version of pre-compiled release binary | `string` | `"v0.1.5"` | no |

---

## Outputs

| Name | Description |
| :--- | :--- |
| `binary_path` | Absolute path to the resolved `tfout` binary executable |
| `banner_command` | Full command line string executed during apply |

---

## How It Works Under the Hood

1. The `external` provider runs a lightweight OS and architecture resolution script (`get_tfout.sh` on Unix / `get_tfout.ps1` on Windows).
2. If `tfout` is already installed on PATH, it uses the local binary.
3. If not found, it downloads the pre-compiled standalone binary for the host system into `.tfout/bin/`.
4. A `null_resource` provisioner executes `tfout banner` during `terraform apply`.

---

## License

[Apache License 2.0](LICENSE)
