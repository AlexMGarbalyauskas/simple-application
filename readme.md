# Devops Example Project

# Project Dependencies
1. Node.js
2. Truffle
...
---
# Install Dependencies
1. use the cd command to navigate to the downloaded projects directory
2. Run the npm install command

# Run Project
1. use the cd command to navigate to the downloaded projects directory
2. Run the npm start command to run the project

***

# Docker (Local)
1. Build image:
	docker build -t simpleapp .
2. Run container:
	docker run -p 3000:3000 simpleapp
3. Open:
	http://localhost:3000

# CircleCI Environment Variables
Set these in CircleCI Project Settings → Environment Variables:

- AWS_REGION
- AWS_ACCOUNT_ID
- ECR_REPOSITORY
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- EB_S3_BUCKET
- EB_APP_NAME
- EB_ENV_NAME
- APP_HTTPS_URL (optional, for post-deploy HTTPS check)
- FORCE_HTTPS=true (set in Elastic Beanstalk environment variables)

Pipeline flow in `.circleci/config.yml` is:
build → test → security-scan → docker-build-and-push → deploy-elastic-beanstalk → verify-https

# Q(b) HTTPS and SSL/TLS in DevOps Pipelines
Implementation in this project:
- HTTPS enforcement is implemented in `app.js` by redirecting HTTP requests to HTTPS when `FORCE_HTTPS=true`.
- HSTS (`Strict-Transport-Security`) is added for HTTPS responses to force secure browser connections.
- Certificate handling is expected at the Elastic Beanstalk load balancer using AWS Certificate Manager (ACM).
- CI/CD validates secure deployment using the `verify-https` job in CircleCI, which checks the deployed HTTPS endpoint and verifies the HSTS header.

How HTTPS and SSL/TLS improve pipeline security:
- Encrypts traffic in transit, preventing credential/session leakage and man-in-the-middle interception.
- Authenticates the server with trusted certificates, reducing spoofing risk.
- Makes secure transport verifiable in automation (post-deploy checks), so insecure releases fail fast.
- HSTS reduces downgrade attacks by requiring browsers to use HTTPS for future requests.

