# AWS Infrastructure Laboratory via Terraform (IaC)

A hands-on laboratory project demonstrating the design, implementation, and deployment of a secure, scalable, and resilient AWS cloud infrastructure using Terraform (Infrastructure as Code). 



---

## 🏗️ Architecture Overview

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
        
        subgraph VPC 1: Public Ingress & Edge Layer
            IGW[Internet Gateway]
            Public_RT[Public Route Table]
            NAT_GW[NAT Gateway]
            EC2_Public[EC2 Instance - Public Subnet]
        end

        subgraph VPC 2: Application Layer Private
            Private_RT_App[Private Route Table]
            EC2_App[EC2 Instances - App Subnet]
        end

        subgraph VPC 3: Data & Storage Layer Isolated
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


