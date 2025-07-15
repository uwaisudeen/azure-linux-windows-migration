# ☁️ Azure Workload Migration using Terraform - Hub-Spoke Architecture

This repository contains infrastructure-as-code projects for migrating workloads to Azure using a **Hub-Spoke architecture** and **Terraform**.

## 📂 Projects

### 🐧 Linux Workload Migration

Migrate Linux-based workloads (e.g., web apps and PostgreSQL) from on-premises to Azure.

🔗 [View Linux code](./Linux/)

🔗 [View Linux Documentation](./Linux/README.md)

### 🪟 Windows Workload Migration

Migrate Windows Server and SQL Server workloads from on-premises to Azure using secure, best-practice-based architecture.

🔗 [View Windows code](./Windows/)

🔗 [View Windows Documentation](./Windows/READme.md)

## 🚀 Highlights

- 🔁 Modular Terraform design for reusability
- 🔐 Built-in security with NSGs, Firewall, Bastion, and Private Endpoints
- 🌉 Site-to-Site VPN setup for hybrid network connectivity
- 📘 Fully automated IaC deployments for both Linux and Windows environments

---

📁 Explore individual folders (`Linux`, `Windows`) for full Terraform code and documentation.

---



## 🚀 Getting Started

```bash
# Clone the repository
$ git clone https://github.com/aflalahmad/terraform-azure-linux-windows-migration

# Navigate to linux working directory
$ cd terraform-linux

## Navigate to windows working directory
$ cd terraform-windows

# Initialize Terraform
$ terraform init

# Validate configuration
$ terraform validate

# Apply configuration
$ terraform apply
```

---

## 👨‍💻 Author
| Name                     | Role                        | LinkedIn                                                                  |
| ------------------------ | --------------------------- | ------------------------------------------------------------------------- |
| **Aflal Ahmad**          | Cloud Engineer @ CloudSlize | [aflalahmadav](https://www.linkedin.com/in/aflalahmadav/)                 |
| **Mohamed Uwaisudeen**   | Cloud Engineer @ CloudSlize | [mduwaisudeen](https://www.linkedin.com/in/mduwaisudeen/)                 |
| **Alfareed Bin Alameen** | Cloud Engineer @ CloudSlize | [alfareed-bin-alameen](https://www.linkedin.com/in/alfareed-bin-alameen/) |


## 🙏 Feedback

Was this documentation helpful?
[![Yes](https://img.shields.io/badge/Yes-blue?style=for-the-badge)](#) [![No](https://img.shields.io/badge/No-blue?style=for-the-badge)](#)

---

<div align="center">

[![Thanks](https://img.shields.io/badge/Thank_You!-blue?style=for-the-badge)](#)

</div>
