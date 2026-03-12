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

Pipeline flow in `.circleci/config.yml` is:
build → test → security-scan → docker-build-and-push → deploy-elastic-beanstalk

