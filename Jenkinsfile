pipeline {
    agent {
        label "maven"
    }
    options { 
        skipDefaultCheckout()
        disableConcurrentBuilds()
    }
    stages {
        stage("Checkout") {
            steps {
                checkout(scm)   
            }
        }
        stage("Test") {
            steps {
                sh "mvn test"
            }
        }
        stage("Build") {
            steps {
                script {
                    openshift.withCluster {
                        openshift.withProject {
                            env.TAG = readMavenPom().getVersion()
                            openshift.selector("bc", "hello-openshift").startBuild("--wait=true")
                            openshift.tag("hello-dev/hello-openshift:latest", "hello-openshift:${env.TAG}")
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
                            if (!openshift.selector("dc", "hello-openshift").exists()) {
                                openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                                  "-p APPLICATION_NAME=hello-openshift", 
                                                                  "-p IMAGE_NAME=hello-openshift", 
                                                                  "-p IMAGE_TAG_NAME=${env.TAG}"))
                            } else {
                                openshift.set("triggers", "dc/hello-openshift", "--remove-all")
                                openshift.set("triggers", "dc/hello-openshift", "--from-image=hello-openshift:${env.TAG}", "-c hello-openshift")
                            }
                            
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
                            openshift.tag("hello-dev/hello-openshift:${env.TAG}", "hello-openshift:${env.TAG}")
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
                            if (!openshift.selector("dc", "hello-openshift").exists()) {
                                openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                                  "-p APPLICATION_NAME=hello-openshift", 
                                                                  "-p IMAGE_NAME=hello-openshift", 
                                                                  "-p IMAGE_TAG_NAME=${env.TAG}"))
                            } else {
                                openshift.set("triggers", "dc/hello-openshift", "--remove-all")
                                openshift.set("triggers", "dc/hello-openshift", "--from-image=hello-openshift:${env.TAG}", "-c hello-openshift")
                            }
                            
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
                            if (!openshift.selector("dc", "hello-openshift").exists()) {
                                openshift.apply(openshift.process(readFile("src/main/resources/deploy.yaml"), 
                                                                  "-p APPLICATION_NAME=hello-openshift", 
                                                                  "-p IMAGE_NAME=hello-openshift", 
                                                                  "-p IMAGE_TAG_NAME=${env.TAG}"))
                            } else {
                                openshift.set("triggers", "dc/hello-openshift", "--remove-all")
                                openshift.set("triggers", "dc/hello-openshift", "--from-image=hello-openshift:${env.TAG}", "-c hello-openshift")
                            }
                            
                            openshift.selector("dc", "hello-openshift").rollout().status()
                        }
                    }
                }
            }
        }
    }
}