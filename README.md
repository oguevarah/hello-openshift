# Hello OpenShift

A simple Hello World application for demonstration of OpenShift concepts.

## Deploy in OpenShift

Run the following commands (or run the [demo.sh](demo.sh) script):

    oc new-project hello-dev
    oc new-project hello-test
    oc new-project hello-prod

    oc create -f src/main/resources/build.yaml -n hello-dev
    oc process -f src/main/resources/deploy.yaml | oc create -f - -n hello-dev

    oc new-app --template=jenkins-ephemeral -n hello-dev

    oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-test
    oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-prod

    oc new-build https://github.com/leandroberetta/hello-openshift.git --name hello-openshift-pipeline --strategy=pipeline -n hello-dev

