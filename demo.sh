#! /usr/bin/env bash

# Create the environments (DEV, TEST & PROD)
oc new-project hello-dev
oc new-project hello-test
oc new-project hello-prod

# Create the build objects in DEV
oc create -f src/main/resources/build.yaml -n hello-dev

# Create a Jenkins instance to run the pipeline in DEV
oc new-app --template=jenkins-ephemeral -n hello-dev

# Give edit permissions to Jenkins Service Account on TEST and PROD environments 
oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-test
oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-prod

# Start the pipeline
oc start-build bc/hello-openshift-pipeline -n hello-dev