```mermaid
graph TD
    %% Styling
    classDef internet fill:#f9f,stroke:#333,stroke-width:2px;
    classDef public_vpc fill:#e1f5fe,stroke:#0288d1,stroke-width:2px;
    classDef private_vpc fill:#efebe9,stroke:#5d4037,stroke-width:2px;
    classDef aws_service fill:#fff3e0,stroke:#ffb74d,stroke-width:2px;

    %% External World
    Internet((Internet)):::internet
    Route53[AWS Route53 DNS]:::aws_service

    %% AWS Infrastructure
    subgraph AWS Cloud
        direction LR
        
        subgraph VPC 1: Public Ingress & Edge Layer[cite: 1]
            IGW[Internet Gateway]
            Public_RT[Public Route Table]
            NAT_GW[NAT Gateway]
            EC2_Public[EC2 Instance - Public Subnet]
        end

        subgraph VPC 2: Application Layer Private[cite: 1]
            Private_RT_App[Private Route Table]
            EC2_App[EC2 Instances - App Subnet]
        end

        subgraph VPC 3: Data & Storage Layer Isolated[cite: 1]
            Private_RT_Data[Isolated Route Table]
            S3_Bucket[(AWS S3 Bucket)]:::aws_service
        end
    end

    %% Traffic and Connections Logic
    Internet <--> Route53
    Internet <--> IGW
    IGW --> Public_RT
    Public_RT --> EC2_Public
    EC2_Public --> NAT_GW
    
    %% Routing Between Layers
    NAT_GW -.-> Private_RT_App
    Private_RT_App --> EC2_App
    EC2_App -.-> Private_RT_Data
    Private_RT_Data --> S3_Bucket

    %% Security & IAM
    IAM[AWS IAM & Security Groups]:::aws_service -.-> Security_Rules[Least-Privilege Access Control]
    Security_Rules --> EC2_Public
    Security_Rules --> EC2_App

# AWS Infrastructure Laboratory via Terraform (IaC)

A hands-on laboratory project demonstrating the design, implementation, and deployment of a secure, scalable, and resilient AWS cloud infrastructure using Terraform (Infrastructure as Code). 

This repository serves as a portfolio-level showcase of my modern DevOps practices, multi-layer networking design, and systems engineering mindset.

---

## 🏗️ Architecture Overview

The lab simulates an enterprise-grade AWS environment built around high-availability and security-first design principles, featuring a **3-VPC Architecture**[cite: 1]:

* **Networking & Segmentation:** 3 separate VPCs isolated to prevent blast radius, custom Route Tables, Internet Gateways, and a NAT Gateway setup for controlled outbound traffic from private resources[cite: 1].
* **Compute Layer:** Configured Amazon EC2 instances spread across multiple Availability Zones for fault tolerance[cite: 1].
* **Identity & Security:** Granular access management using AWS IAM roles, tailored Security Groups (acting as stateful firewalls), and least-privilege policies[cite: 1].
* **Storage & DNS:** S3 buckets for object storage (ideal for state management or application assets) and Route53 for managed private/public DNS routing[cite: 1].

---

## 🛠️ DevOps Stack & Core Tools

* **Infrastructure as Code:** Terraform (HCL)[cite: 1]
* **Cloud Provider:** Amazon Web Services (AWS)[cite: 1]
* **Operating Systems:** Linux (Ubuntu / Amazon Linux)[cite: 1]
* **Version Control:** Git & GitHub

---

## 📁 Repository Structure

```text
├── main.tf           # Main configuration file defining the core infrastructure resources
├── variables.tf      # Input variables to ensure parameterization and reusability
├── outputs.tf        # Explicit output definitions (e.g., public IPs, DNS names, VPC IDs)
├── providers.tf      # AWS provider specifications and version locking
└── README.md         # Documentation

