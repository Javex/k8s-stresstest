# k8s-stresstest
A deployment where you create stress on Kubernetes Cluster

This tool is based on the [Ubuntu Package of stress](https://packages.ubuntu.com/focal/stress)
which generates CPU/Memory load, or Disc i/o. We focus on CPU/Memory load
to test auto-scaling in your Kubernetes cluster, for example.

Checkout the [Dockerfile](Dockerfile) for configuration options:

```
ENV STRESS_CPU=1
ENV STRESS_VM=1
ENV STRESS_VM_BYTES=256M
ENV STRESS_TIMEOUT=3600s
```

These vars can be overwritten in [deployment.yaml](kubernetes/deployment.yaml)
We added RBAC, and the horizontal auto-scaling deployment:

```
$ kubectl create namespace loadtest
$ kubectl -n loadtest apply -f ./kubernetes/
```

After a while the stress is running and PODs are scalled to the maximum:


```
$ kubectl -n loadtest get hpa
NAME     REFERENCE           TARGETS      MINPODS   MAXPODS   REPLICAS   AGE
stress   Deployment/stress   10002%/80%   1         5         5          5m33s
```

```
$ kubectl -n loadtest top pods
NAME                      CPU(cores)   MEMORY(bytes)
stress-64bd56b969-986v2   1000m        2Mi
stress-64bd56b969-9s9rb   998m         2Mi
stress-64bd56b969-bjmvs   1000m        2Mi
stress-64bd56b969-p49m5   1002m        2Mi
stress-64bd56b969-zkb6r   1001m        2Mi
```

Increase hpa to a maximum to scale up more worker nodes, i.e. with [Scalr](https://cmp.docs.scalr.com/en/latest/farms/scaling.html#dynamic-autoscaling).

Hint: For `Warning FailedGetResourceMetric horizontal-pod-autoscaler missing request for cpu`
 look at this [issue](https://github.com/kubernetes/kubernetes/issues/79365)

Credits:
-------

@eribertomota (stress maintainer)

Frank Kloeker <f.kloeker@telekom.de>

Life is for sharing. If you have an issue with the code or want to improve it,
feel free to open an issue or an pull request.
