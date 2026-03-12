# DevOps Architecture Explanation (CI vs CD with Continuous Security)

## Overview
The architecture separates **Continuous Integration (CI)** and **Continuous Delivery/Deployment (CD)** while enforcing **Continuous Security** controls across both stages.

- **CI** begins when code is pushed to GitHub and focuses on building, testing, scanning, and packaging artifacts.
- **CD** takes validated artifacts and deploys them to AWS Elastic Beanstalk, then verifies runtime security checks.
- **Continuous Security** is embedded throughout the pipeline via secrets management, IAM controls, dependency scanning, and HTTPS/TLS verification.

## (a) Tools/Services Used at Each Stage

### Source Control and Trigger Stage
- **GitHub**: hosts source code, Dockerfile, and CI configuration.
- **GitHub Webhook → CircleCI**: triggers pipeline execution on each push.

### Continuous Integration (CI) Stage
- **CircleCI**: orchestrates jobs and workflow sequencing.
- **Node.js + npm**:
  - `npm ci` for deterministic dependency installation.
  - `npm test` for automated test execution.
- **npm audit**: scans dependencies for known vulnerabilities.
- **Docker**: builds container image from source.
- **Amazon ECR**: stores image artifacts (`SHA` and `latest` tags).

### Continuous Delivery/Deployment (CD) Stage
- **AWS S3**: stores deployment bundles for Elastic Beanstalk versioning.
- **AWS Elastic Beanstalk**: deploys and runs the application environment.
- **CircleCI verify-https job**: post-deploy runtime verification of HTTPS and HSTS behavior.

### Continuous Security Layer (Cross-Cutting)
- **CircleCI Environment Variables**: stores deployment secrets and runtime endpoints.
- **AWS IAM**: enforces permission boundaries for deployment identity.
- **HTTPS + SSL/TLS (ACM/LB termination)**: protects data in transit.
- **HSTS Header**: prevents protocol downgrade and forces secure browser connections.

## (b) How Each Tool/Service Contributes to CI, CD, and Continuous Security

### Continuous Integration Contributions
- **GitHub + CircleCI** automate integration by running a pipeline on every commit.
- **npm ci** ensures reproducible build behavior across runners.
- **npm test** provides quality gates before artifacts are accepted.
- **Docker build** standardizes runtime packaging and reduces environment drift.
- **ECR push** creates a traceable, versioned artifact for release.

### Continuous Delivery/Deployment Contributions
- **Elastic Beanstalk deployment commands** promote validated versions into an environment consistently.
- **S3 application bundles** provide versioned deployment inputs and rollback support.
- **Workflow ordering** (build → test → security → docker → deploy → verify) ensures only validated outputs reach runtime.

### Continuous Security Contributions
- **npm audit** shifts vulnerability detection left during CI.
- **IAM policy controls** reduce blast radius by limiting what deployment credentials can do.
- **CircleCI secret variables** avoid hardcoding credentials in source code.
- **HTTPS/TLS + HSTS** ensure transport encryption, endpoint authenticity, and stronger browser security posture.
- **Post-deploy HTTPS verification** enforces security as a release gate, not just a one-time setup task.

## CI vs CD Difference (Clearly Highlighted)
- **CI** answers: *Is this code change safe, buildable, testable, and securable?*
- **CD** answers: *Can the validated artifact be delivered and run safely in the target environment?*
- **Continuous Security** ensures both answers are trustworthy by embedding security checks in every stage.
