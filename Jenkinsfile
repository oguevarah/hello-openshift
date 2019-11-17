pipeline {
    agent any
    options { 
        skipDefaultCheckout()
        disableConcurrentBuilds()
    }
    stages {
        stage("Checkout") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject {
                            def bc = openshift.selector("bc", "hello-openshift").object()

                            git branch: "master", url: bc.spec.source.git.uri
                        }
                    }
                }
            }
        }
        stage("Build") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject {
                            openshift.selector("bc", "hello-openshift").startBuild("--wait=true")
                        }
                    }
                }
            }
        }
        stage("Deploy DEV") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject {
                            openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                              "-p APPLICATION_NAME=hello-openshift", 
                                                              "-p APPLICATION_VERSION=latest"))

                            openshift.selector("dc", "hello-openshift").rollout().status()
                        }
                    }
                }
            }
        }
        stage("Promote TEST") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject("hello-test") {
                            env.TAG = readMavenPom().getVersion()
                            openshift.tag("hello-dev/hello-openshift:latest", "hello-openshift:${env.TAG}")
                        }
                    }
                }
            }
        }
        stage("Deploy TEST") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject("hello-test") {
                            openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                              "-p APPLICATION_NAME=hello-openshift", 
                                                              "-p APPLICATION_VERSION=${env.TAG}"))

                            openshift.selector("dc", "hello-openshift").rollout().status()
                        }
                    }
                }
            }
        }
        stage("Promote PROD") {
            steps {
                script {
                    input("Promote to PROD?")
                    openshift.withCluster {
                        openshift.withProject("hello-prod") {
                            env.TAG = readMavenPom().getVersion()
                            openshift.tag("hello-test/hello-openshift:${env.TAG}", "hello-openshift:${env.TAG}")
                        }
                    }
                }
            }
        }
        stage("Deploy PROD") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject("hello-prod") {
                            openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                              "-p APPLICATION_NAME=hello-openshift", 
                                                              "-p APPLICATION_VERSION=${env.TAG}"))

                            openshift.selector("dc", "hello-openshift").rollout().status()
                        }
                    }
                }
            }
        }
    }
}