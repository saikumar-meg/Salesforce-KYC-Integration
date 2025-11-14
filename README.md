A complete end-to-end Salesforce application that performs KYC (Know Your Customer) verification, integrates with an external API, logs verification results, and displays analytics using Lightning Web Components and Apex.

📌 Overview

This project simulates a real-world KYC integration using Salesforce.
It includes:

External API callout using Named Credentials

Apex service layer for verification logic

LWC frontend for data capture

Audit logging using a Salesforce Custom Object

Trend analytics (Apex + LWC Dashboard)

DevOps-ready folder structure with tests

GitHub tracking with Issues + Project Kanban

This project follows Salesforce enterprise design patterns, including controller–service separation, test-driven development, error handling, and modular LWCs.

🚀 Features
1. KYC API Integration

Validates customer details (Name, SSN, DOB)

Uses mock REST API endpoint

Handles success & error cases

Structured JSON request/response

Built using:

HttpRequest

HttpResponse

Named Credential

2. KYC Verifier (LWC UI)

Capture First Name, Last Name, DOB, and SSN

Calls Apex controller for verification

Displays:

Status (APPROVED/REVIEW/REJECTED)

Reason

Request ID

Timestamp

3. Audit Logging

Custom object: KYC_Log__c

Fields:

Status

Reason

Customer Name

Request ID

Timestamp

Automatic log creation using:

Apex service (KycLogService)

Flow automation

4. KYC Analytics

Daily verification counts

Summary totals for last 7/14/30 days

REST-like Apex data API

Lightweight dashboards built with LWC

kycSummary

kycTrendChart

5. Apex Tests

Tests for:

Callout mock

Service logic

Logging

Analytics

Achieves 85%+ coverage

📁 Project Structure
force-app/main/default/
│
├── classes/
│   ├── KycService.cls
│   ├── KycServiceTest.cls
│   ├── KycServiceMock.cls
│   ├── KycController.cls
│   ├── KycLogService.cls
│   ├── KycLogServiceTest.cls
│   ├── KycAnalytics.cls
│   ├── KycAnalyticsTest.cls
│   ├── KycTrendController.cls
│   ├── KycTrendControllerTest.cls
│
├── lwc/
│   ├── kycVerifier/
│   ├── kycSummary/
│   ├── kycTrendChart/
│
└── objects/
    └── KYC_Log__c/

🔧 Technical Architecture

Frontend (LWC UI):

kycVerifier → Run KYC check

kycSummary → Summary dashboard

kycTrendChart → Trend analytics chart

Backend (Apex):

KycService → Handles API callout

KycController → Exposes Apex to LWC

KycLogService → Creates audit logs

KycAnalytics → Returns summary metrics

KycTrendController → Returns trend data

Database:

Custom Object: KYC_Log__c
