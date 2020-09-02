# Hybrid Cloud

## Download Sources

```shell
git clone https://github.com/redhat-developer-demos/hybrid-cloud
export HYBRID_CLOUD_HOME=`pwd`/hybrid-cloud
git clone https://github.com/redhat-developer-demos/hybrid-cloud-app-frontend
export BACKEND_APP_HOME=`pwd`/hybrid-cloud-app-frontend
git clone https://github.com/redhat-developer-demos/hybrid-cloud-app-backend
export FRONTEND_HOME=`pwd`/hybrid-cloud-app-frontend
```

Lets use the following variables to denote the source repositories cloned above

- *$HYBRID_CLOUD_HOME* -- <https://github.com/redhat-developer-demos/hybrid-cloud>
- *$BACKEND_APP_HOME* -- <https://github.com/redhat-developer-demos/hybrid-cloud>
- *$FRONTEND_HOME* -- <https://github.com/redhat-developer-demos/hybrid-cloud>

For rest of the document we will call $REPO_HOME; the folder where you have cloned the <https://github.com/redhat-developer-demos/hybrid-cloud>.

## Pre-requsites

Atleast 2 OpenShift 4 cluster with following components installed:

- OpenShift Serverless

On all clouds where you wish to deploy backend run the following commands:

```shell
cd $HYBRID_CLOUD_HOME
oc apply -k k8s/core
oc project hybrid-cloud-demo
oc apply -k k8s/rbac
oc apply -k k8s/skupper
```

Wait for skupper deployments to be ready:

```shell
oc rollout status deployment skupper-site-controller
oc rollout status deployment skupper-router
oc rollout status deployment skupper-service-controller
```

## Backend Deployment

On all clouds where you wish to deploy *backend* run the following commands:

Deploy backend application(Knative):

```shell
cd $BACKEND_APP_HOME
oc apply -k k8s/knative
```

A successfull deployment of core and backend services should show a output like:

```shell
oc get pods,svc,ksvc
```

```text
NAME                                                        READY   STATUS    RESTARTS   AGE
pod/hybrid-cloud-backend-p948k-deployment-b49c9569b-ggv8z   2/2     Running   0          26s
pod/skupper-router-56c4544bbc-dhckt                         3/3     Running   0          43m
pod/skupper-service-controller-5bcf486799-v2hl2             2/2     Running   0          43m
pod/skupper-site-controller-5cf967f858-z2dx8                1/1     Running   0          43m

NAME                                         TYPE           CLUSTER-IP       EXTERNAL-IP                                                  PORT(S)                             AGE
service/hybrid-cloud-backend                 ExternalName   <none>           kourier-internal.knative-serving-ingress.svc.cluster.local   <none>                              21s
service/hybrid-cloud-backend-p948k           ClusterIP      172.30.223.229   <none>                                                       80/TCP                              26s
service/hybrid-cloud-backend-p948k-private   ClusterIP      172.30.140.107   <none>                                                       80/TCP,9090/TCP,9091/TCP,8022/TCP   26s
service/hybrid-cloud-backend-skupper         LoadBalancer   172.30.1.23      <pending>                                                    80:31554/TCP                        29s
service/skupper-controller                   ClusterIP      172.30.119.15    <none>                                                       443/TCP                             43m
service/skupper-internal                     ClusterIP      172.30.205.136   <none>                                                       55671/TCP,45671/TCP                 43m
service/skupper-messaging                    ClusterIP      172.30.14.214    <none>                                                       5671/TCP                            43m
service/skupper-router-console               ClusterIP      172.30.72.116    <none>                                                       443/TCP                             43m

NAME                                               URL                                                                 LATESTCREATED                LATESTREADY                  READY   REASON
service.serving.knative.dev/hybrid-cloud-backend   http://hybrid-cloud-backend-hybrid-cloud-demo.apps.gcp.kameshs.me   hybrid-cloud-backend-p948k   hybrid-cloud-backend-p948k   True
```

## Retrieve the Skupper connection Token

The skupper controller will update the secret *site-token*, with the connection token details. Retrieve the token to be used, by:

```shell
oc get secret site-token -o yaml > $HYBRID_CLOUD_HOME/token.yaml
```

Now run the following command on all clouds both *frontend* and *backend*:

__NOTE__: You dont need to run this on the *backend* cloud where token was generated.

```shell
oc create -f $HYBRID_CLOUD_HOME/token.yaml
```

### Verify Status

Running `skupper status` on the clouds should show the following output:

```shell
Skupper is enabled for namespace '"hybrid-cloud-demo" in interior mode'. It is connected to 1 other site. It has 1 exposed service.
```

### Verify Exposed Services

You can verify that, in all connected clouds running the following command `skupper list-exposed` shows the following output:

```shell
Services exposed through Skupper:
    hybrid-cloud-backend-skupper (http port 80) with targets
      => hybrid-cloud-backend.hybrid-cloud-demo name=hybrid-cloud-backend.hybrid-cloud-demo
```

## Frontend Deployment

On cloud where you wish to deploy *frontend* run the following commands:

Deploy frontend application:

```shell
cd $FRONTEND_APP_HOME
oc apply -k k8s/knative
```

```shell
oc create route edge  --service=hybrid-cloud-frontend --port=8080
```
