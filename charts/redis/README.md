# Redis

[Redis](http://redis.io/) is an advanced key-value cache and store. It is often referred to as a data structure server since keys can contain strings, hashes, lists, sets, sorted sets, bitmaps and hyperloglogs.

This chart runs a single, standalone Redis server as a one-pod StatefulSet, using the official [redis](https://hub.docker.com/_/redis/) image.

It is derived from the [redis-ha](https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha) chart, with Sentinel, HAProxy, replication and split-brain detection removed. Use `redis-ha` if you need failover.

## Installing the Chart

```bash
helm install redis ./charts/redis
```

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

```bash
helm delete redis
```

The command removes all the Kubernetes components associated with the chart and deletes the release. The `PersistentVolumeClaim` created by the StatefulSet is kept and has to be deleted separately.

## Configuration

The following table lists the configurable parameters of the Redis chart and their default values.

### General parameters

| Parameter | Description | Type | Default |
|-----|------|---------|-------------|
| `additionalAffinities` | Additional affinities to add to the Redis server pods. # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#affinity-and-anti-affinity | object | `{}` |
| `affinity` | Override all other affinity settings for the Redis server pods with a string. | string | `""` |
| `auth` | Configures redis with AUTH (requirepass conf param) | bool | `false` |
| `authKey` | Defines the key holding the redis password in existing secret. | string | `"auth"` |
| `authSecretAnnotations` | Annotations for auth secret | object | `{}` |
| `configmap.labels` | Custom labels for the redis configmap | object | `{}` |
| `configmapTest.image` | Image for redis-ha-configmap-test hook | object | `{"repository":"koalaman/shellcheck","tag":"v0.11.0"}` |
| `configmapTest.image.repository` | Repository of the configmap shellcheck test image. | string | `"koalaman/shellcheck"` |
| `configmapTest.image.tag` | Tag of the configmap shellcheck test image. | string | `"v0.11.0"` |
| `configmapTest.resources` | Resources for the ConfigMap test pod | object | `{}` |
| `containerSecurityContext` | Security context to be added to the Redis containers. | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":1000,"seccompProfile":{"type":"RuntimeDefault"}}` |
| `emptyDir` | Configuration of `emptyDir`, used only if persistentVolume is disabled and no hostPath specified | object | `{}` |
| `existingSecret` | An existing secret containing a key defined by `authKey` that configures `requirepass` in the conf parameters (Requires `auth: enabled`, cannot be used in conjunction with `.Values.redisPassword`) | string | `nil` |
| `extraContainers` | Extra containers to include in StatefulSet | list | `[]` |
| `extraInitContainers` | Extra init containers to include in StatefulSet | list | `[]` |
| `extraLabels` | Labels added here are applied to all created resources | object | `{}` |
| `extraVolumes` | Extra volumes to include in StatefulSet | list | `[]` |
| `fullnameOverride` | Full name of the Redis HA Resources | string | `""` |
| `global.compatibility` | Openshift compatibility options | object | `{"openshift":{"adaptSecurityContext":"auto"}}` |
| `global.priorityClassName` | Default priority class for all components | string | `""` |
| `hardAntiAffinity` | Whether the Redis server pods should be forced to run on separate nodes. # This is accomplished by setting their AntiAffinity with requiredDuringSchedulingIgnoredDuringExecution as opposed to preferred. # Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/#inter-pod-affinity-and-anti-affinity-beta-feature | bool | `true` |
| `hostPath.chown` | if chown is true, an init-container with root permissions is launched to change the owner of the hostPath folder to the user defined in the security context | bool | `true` |
| `hostPath.path` | Use this path on the host for data storage. path is evaluated as template so placeholders are replaced | string | `""` |
| `image.pullPolicy` | Redis image pull policy | string | `"IfNotPresent"` |
| `image.repository` | Redis image repository | string | `"public.ecr.aws/docker/library/redis"` |
| `image.tag` | Redis image tag | string | `"8.8.0-alpine"` |
| `imagePullSecrets` | Reference to one or more secrets to be used when pulling redis images | list | `[]` |
| `init.resources` | Extra init resources | object | `{}` |
| `labels` | Custom labels for the redis pod | object | `{}` |
| `nameOverride` | Name override for Redis HA resources | string | `""` |
| `networkPolicy.annotations` | Annotations for NetworkPolicy | object | `{}` |
| `networkPolicy.egressRules` | user can define egress rules too, uses the same structure as ingressRules | list | `[{"ports":[{"port":53,"protocol":"UDP"},{"port":53,"protocol":"TCP"}],"selectors":[{"namespaceSelector":{}},{"ipBlock":{"cidr":"169.254.0.0/16"}}]}]` |
| `networkPolicy.egressRules[0].selectors[0]` | Allow all destinations for DNS traffic | object | `{"namespaceSelector":{}}` |
| `networkPolicy.enabled` | whether NetworkPolicy for Redis StatefulSets should be created. when enabled, inter-Redis connectivity is created | bool | `false` |
| `networkPolicy.ingressRules` | User defined ingress rules that Redis should permit into. Uses the format defined in https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors | list | `[]` |
| `networkPolicy.labels` | Labels for NetworkPolicy | object | `{}` |
| `nodeSelector` | Node labels for pod assignment | object | `{}` |
| `persistentVolume.accessModes` | Persistent volume access modes | list | `["ReadWriteOnce"]` |
| `persistentVolume.annotations` | Annotations for the volume | object | `{}` |
| `persistentVolume.enabled` | Enable persistent volume | bool | `true` |
| `persistentVolume.labels` | Labels for the volume | object | `{}` |
| `persistentVolume.size` | Persistent volume size | string | `"10Gi"` |
| `persistentVolume.storageClass` | redis-ha data Persistent Volume Storage Class | string | `nil` |
| `podDisruptionBudget` | Pod Disruption Budget rules | object | `{}` |
| `podManagementPolicy` | The statefulset pod management policy | string | `"OrderedReady"` |
| `priorityClassName` | Kubernetes priorityClass name for the redis-ha-server pod | string | `""` |
| `redis.annotations` | Annotations for the redis statefulset | object | `{}` |
| `redis.authClients` | It is possible to disable client side certificates authentication when "authClients" is set to "no" | string | `""` |
| `redis.config` | Any valid redis config options in this section will be applied to each server, For multi-value configs use list instead of string (for example loadmodule) (see below) | object | see values.yaml |
| `redis.config.maxmemory` | Max memory to use for each redis instance. Default is unlimited. | string | `"0"` |
| `redis.config.maxmemory-policy` | Max memory policy to use for each redis instance. Default is volatile-lru. | string | `"volatile-lru"` |
| `redis.config.save` | Determines if scheduled RDB backups are created. Default is false. | string | `"900 1"` |
| `redis.customArgs` | Allows overriding the redis container arguments | list | `[]` |
| `redis.customCommand` | Allows overriding the redis container command | list | `[]` |
| `redis.customConfig` | Allows for custom redis.conf files to be applied. If this is used then `redis.config` is ignored | string | `nil` |
| `redis.disableCommands` | Array with commands to disable | list | `["FLUSHDB","FLUSHALL"]` |
| `redis.envFrom` | Load environment variables from ConfigMap/Secret | list | `[]` |
| `redis.extraVolumeMounts` | additional volumeMounts for Redis container | list | `[]` |
| `redis.lifecycle` | Container Lifecycle Hooks for redis container Ref: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/ | object | see values.yaml |
| `redis.livenessProbe` | Liveness probe parameters for redis container | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}` |
| `redis.livenessProbe.enabled` | Enable the Liveness Probe | bool | `true` |
| `redis.livenessProbe.failureThreshold` | Failure threshold for liveness probe | int | `5` |
| `redis.livenessProbe.initialDelaySeconds` | Initial delay in seconds for liveness probe | int | `30` |
| `redis.livenessProbe.periodSeconds` | Period in seconds after which liveness probe will be repeated | int | `15` |
| `redis.livenessProbe.successThreshold` | Success threshold for liveness probe | int | `1` |
| `redis.livenessProbe.timeoutSeconds` | Timeout seconds for liveness probe | int | `15` |
| `redis.minReadySeconds` | Configure the 'minReadySeconds' parameter to StatefulSet ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#minreadyseconds | int | `0` |
| `redis.podAnnotations` | Annotations to be added to the redis statefulset pods | object | `{}` |
| `redis.port` | Port to access the redis service | int | `6379` |
| `redis.readinessProbe` | Readiness probe parameters for redis container | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}` |
| `redis.readinessProbe.enabled` | Enable the Readiness Probe | bool | `true` |
| `redis.readinessProbe.failureThreshold` | Failure threshold for readiness probe | int | `5` |
| `redis.readinessProbe.initialDelaySeconds` | Initial delay in seconds for readiness probe | int | `30` |
| `redis.readinessProbe.periodSeconds` | Period in seconds after which readiness probe will be repeated | int | `15` |
| `redis.readinessProbe.successThreshold` | Success threshold for readiness probe | int | `1` |
| `redis.readinessProbe.timeoutSeconds` | Timeout seconds for readiness probe | int | `15` |
| `redis.resources` | CPU/Memory resource requests/limits | object | `{}` |
| `redis.startupProbe` | Startup probe parameters for redis container | object | `{"enabled":true,"failureThreshold":5,"initialDelaySeconds":30,"periodSeconds":15,"successThreshold":1,"timeoutSeconds":15}` |
| `redis.startupProbe.enabled` | Enable Startup Probe | bool | `true` |
| `redis.startupProbe.failureThreshold` | Failure threshold for startup probe | int | `5` |
| `redis.startupProbe.initialDelaySeconds` | Initial delay in seconds for startup probe | int | `30` |
| `redis.startupProbe.periodSeconds` | Period in seconds after which startup probe will be repeated | int | `15` |
| `redis.startupProbe.successThreshold` | Success threshold for startup probe | int | `1` |
| `redis.startupProbe.timeoutSeconds` | Timeout seconds for startup probe | int | `15` |
| `redis.terminationGracePeriodSeconds` | Increase terminationGracePeriodSeconds to allow writing large RDB snapshots. (k8s default is 30s) ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#pod-termination-forced | int | `60` |
| `redis.tlsPort` | TLS Port to access the redis service | int | `nil` |
| `redis.updateStrategy` | Update strategy for Redis StatefulSet # ref: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/#update-strategies | object | `{"type":"RollingUpdate"}` |
| `redisPassword` | A password that configures `requirepass` in the conf parameters (Requires `auth: enabled`) | string | `nil` |
| `restore.existingSecret` | Set existingSecret to true to use secret specified in existingSecret above | bool | `false` |
| `restore.redis.source` |  | string | `""` |
| `restore.s3.access_key` | Restore init container - AWS AWS_ACCESS_KEY_ID to access restore.s3.source | string | `""` |
| `restore.s3.region` | Restore init container - AWS AWS_REGION to access restore.s3.source | string | `""` |
| `restore.s3.secret_key` | Restore init container - AWS AWS_SECRET_ACCESS_KEY to access restore.s3.source | string | `""` |
| `restore.s3.source` | Restore init container - AWS S3 location of dump - i.e. s3://bucket/dump.rdb or false | string | `""` |
| `restore.ssh.key` | Restore init container - SSH private key to scp restore.ssh.source to init container. Key should be in one line separated with \n. i.e. `-----BEGIN RSA PRIVATE KEY-----\n...\n...\n-----END RSA PRIVATE KEY-----` | string | `""` |
| `restore.ssh.source` | Restore init container - SSH scp location of dump - i.e. user@server:/path/dump.rdb or false | string | `""` |
| `restore.timeout` | Timeout for the restore | int | `600` |
| `schedulerName` | Use an alternate scheduler, e.g. "stork". ref: https://kubernetes.io/docs/tasks/administer-cluster/configure-multiple-schedulers/ | string | `""` |
| `securityContext` | Security context to be added to the Redis StatefulSet. | object | `{"fsGroup":1000,"runAsNonRoot":true,"runAsUser":1000}` |
| `serviceAccount.annotations` | Annotations to be added to the service account for the redis statefulset | object | `{}` |
| `serviceAccount.automountToken` | opt in/out of automounting API credentials into container. Ref: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/ | bool | `false` |
| `serviceAccount.create` | Specifies whether a ServiceAccount should be created | bool | `true` |
| `serviceAccount.name` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the redis-ha.fullname template | string | `""` |
| `serviceLabels` | Custom labels for redis service | object | `{}` |
| `sysctlImage.command` | sysctlImage command to execute | list | `[]` |
| `sysctlImage.enabled` | Enable an init container to modify Kernel settings | bool | `false` |
| `sysctlImage.mountHostSys` | Mount the host `/sys` folder to `/host-sys` | bool | `false` |
| `sysctlImage.pullPolicy` | sysctlImage Init container pull policy | string | `"Always"` |
| `sysctlImage.registry` | sysctlImage Init container registry | string | `"public.ecr.aws/docker/library"` |
| `sysctlImage.repository` | sysctlImage Init container name | string | `"busybox"` |
| `sysctlImage.resources` | sysctlImage resources | object | `{}` |
| `sysctlImage.tag` | sysctlImage Init container tag | string | `"1.38.0"` |
| `tls.caCertFile` | Name of CA certificate file | string | `"ca.crt"` |
| `tls.certFile` | Name of certificate file | string | `"redis.crt"` |
| `tls.dhParamsFile` | Name of Diffie-Hellman (DH) key exchange parameters file (Example: redis.dh) | string | `nil` |
| `tls.keyFile` | Name of key file | string | `"redis.key"` |
| `tolerations` |  | list | `[]` |
| `topologySpreadConstraints.enabled` | Enable topology spread constraints | bool | `false` |
| `topologySpreadConstraints.maxSkew` | Max skew of pods tolerated | string | `""` |
| `topologySpreadConstraints.topologyKey` | Topology key for spread constraints | string | `""` |
| `topologySpreadConstraints.whenUnsatisfiable` | Enforcement policy, hard or soft | string | `""` |

### Prometheus exporter parameters

| Parameter | Description | Type | Default |
|-----|------|---------|-------------|
| `exporter.address` | Address/Host for Redis instance. Exists to circumvent issues with IPv6 dns resolution that occurs on certain environments | string | `"localhost"` |
| `exporter.enabled` | If `true`, the prometheus exporter sidecar is enabled | bool | `false` |
| `exporter.extraArgs` | Additional args for redis exporter | object | `{}` |
| `exporter.image` | Exporter image | string | `"quay.io/oliver006/redis_exporter"` |
| `exporter.livenessProbe.httpGet.path` | Exporter liveness probe httpGet path | string | `"/metrics"` |
| `exporter.livenessProbe.httpGet.port` | Exporter liveness probe httpGet port | int | `9121` |
| `exporter.livenessProbe.initialDelaySeconds` | Initial delay in seconds for liveness probe of exporter | int | `15` |
| `exporter.livenessProbe.periodSeconds` | Period in seconds after which liveness probe will be repeated | int | `15` |
| `exporter.livenessProbe.timeoutSeconds` | Timeout seconds for liveness probe of exporter | int | `3` |
| `exporter.port` | Exporter port | int | `9121` |
| `exporter.portName` | Exporter port name | string | `"exporter-port"` |
| `exporter.pullPolicy` | Exporter image pullPolicy | string | `"IfNotPresent"` |
| `exporter.readinessProbe.httpGet.path` | Exporter readiness probe httpGet path | string | `"/metrics"` |
| `exporter.readinessProbe.httpGet.port` | Exporter readiness probe httpGet port | int | `9121` |
| `exporter.readinessProbe.initialDelaySeconds` | Initial delay in seconds for readiness probe of exporter | int | `15` |
| `exporter.readinessProbe.periodSeconds` | Period in seconds after which readiness probe will be repeated | int | `15` |
| `exporter.readinessProbe.successThreshold` | Success threshold for readiness probe of exporter | int | `2` |
| `exporter.readinessProbe.timeoutSeconds` | Timeout seconds for readiness probe of exporter | int | `3` |
| `exporter.resources` | cpu/memory resource limits/requests | object | `{}` |
| `exporter.scrapePath` | Exporter scrape path | string | `"/metrics"` |
| `exporter.script` | A custom custom Lua script that will be mounted to exporter for collection of custom metrics. Creates a ConfigMap and sets env var `REDIS_EXPORTER_SCRIPT`. | string | `""` |
| `exporter.serviceMonitor.disableAPICheck` | Disable API Check on ServiceMonitor | bool | `false` |
| `exporter.serviceMonitor.enabled` | When set true then use a ServiceMonitor to configure scraping | bool | `false` |
| `exporter.serviceMonitor.endpointAdditionalProperties` | Set additional properties for the ServiceMonitor endpoints such as relabeling, scrapeTimeout, tlsConfig, and more. | object | `{}` |
| `exporter.serviceMonitor.interval` | Set how frequently Prometheus should scrape (default is 30s) | string | `""` |
| `exporter.serviceMonitor.labels` | Set labels for the ServiceMonitor, use this to define your scrape label for Prometheus Operator | object | `{}` |
| `exporter.serviceMonitor.metricRelabelings` |  | list | `[]` |
| `exporter.serviceMonitor.namespace` | Set the namespace the ServiceMonitor should be deployed | string | `.Release.Namespace` |
| `exporter.serviceMonitor.relabelings` |  | list | `[]` |
| `exporter.serviceMonitor.telemetryPath` | Set path to redis-exporter telemtery-path (default is /metrics) | string | `""` |
| `exporter.serviceMonitor.timeout` | Set timeout for scrape (default is 10s) | string | `""` |
| `exporter.tag` | Exporter image tag | string | `"v1.86.0"` |
| `prometheusRule.additionalLabels` | Additional labels to be set in metadata. | object | `{}` |
| `prometheusRule.enabled` | If true, creates a Prometheus Operator PrometheusRule. | bool | `false` |
| `prometheusRule.interval` | How often rules in the group are evaluated (falls back to `global.evaluation_interval` if not set). | string | `"10s"` |
| `prometheusRule.namespace` | Namespace which Prometheus is running in. | string | `nil` |
| `prometheusRule.rules` | Rules spec template (see https://github.com/prometheus-operator/prometheus-operator/blob/master/Documentation/api.md#rule). | list | `[]` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`, or provide a YAML file:

```bash
helm install redis ./charts/redis -f values.yaml
```

> **Tip**: You can use the default [values.yaml](values.yaml)

## Authentication

Set `auth: true` and either `redisPassword`, or `existingSecret` with the password under the `authKey` key (default `auth`). With `existingSecret`, the chart creates no Secret of its own, so the password has a single owner (for example External Secrets).

## Custom Redis config options

Most redis config options can be passed as key value pairs under `redis.config` in `values.yaml`. See the [example redis.conf](http://download.redis.io/redis-stable/redis.conf) for all available options.

For example `timeout 300` would be added to the `redis.config` section of the `values.yaml` as:

```yml
    timeout: "300"
```

For multi-value options such as `save` or `loadmodule`, use a list.

If more control is needed, an entire config can be defined under `redis.customConfig`. This overrides any options under `redis.config`.

## Persistence

Data is kept on a `PersistentVolumeClaim` by default (`persistentVolume.enabled`). Set it to `false` to use an `emptyDir` instead, for example when Redis only holds data that can be lost on restart.

## Host Kernel Settings

Redis may require some changes in the kernel of the host machine to work as expected, in particular increasing the `somaxconn` value and disabling transparent huge pages.
To do so, you can set up a privileged initContainer with the `sysctlImage` config values, for example:

```yml
sysctlImage:
  enabled: true
  mountHostSys: true
  command:
    - /bin/sh
    - -xc
    - |-
      sysctl -w net.core.somaxconn=10000
      echo never > /host-sys/kernel/mm/transparent_hugepage/enabled
```

## Network policies

If `networkPolicy.enabled` is set to `true`, then a `NetworkPolicy` resource is created with default rules for DNS.

You will need to define `ingressRules` to permit your application connectivity to Redis.
The `selectors` block should be in the format of a [label selector](https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors).
Templating is also supported in the selectors.
See such a configuration below.

```yaml
networkPolicy:
  enabled: true
  ingressRules:
    - selectors:
      - namespaceSelector:
          matchLabels:
            name: my-redis-client-namespace
        podSelector:
          matchLabels:
            # template example
            app: |-
              {{- .App.Name }}
      ## ports block is optional (defaults to below), define the block to override the defaults
      # ports:
      #   - port: 6379
      #     protocol: TCP
```

Should your Pod require additional egress rules, define them in a `egressRules` key which is structured identically to an `ingressRules` key.
