# Hello OpenShift

A simple Hello World application to demonstrate OpenShift concepts.

## Deploy in OpenShift

Run the following commands (or run the [demo.sh](demo.sh) script):

    oc new-project hello-dev
    oc new-project hello-test
    oc new-project hello-prod

    oc create -f src/main/resources/build.yaml -n hello-dev

    oc new-app --template=jenkins-ephemeral -n hello-dev

    oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-test
    oc adm policy add-role-to-user edit system:serviceaccount:hello-dev:jenkins -n hello-prod

    oc start-build bc/hello-openshift-pipeline -n hello-dev