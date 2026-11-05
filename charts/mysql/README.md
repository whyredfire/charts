# MySQL

[MySQL](https://www.mysql.com/) is an open source relational database.

This chart runs a single MySQL server as a one-pod StatefulSet, using the official [mysql](https://hub.docker.com/_/mysql) image. It has no replication, failover or backups. Use the [MySQL Operator](https://github.com/mysql/mysql-operator) if you need those.

## Installing the Chart

```bash
helm install mysql ./charts/mysql \
  --set auth.rootPassword=... --set auth.password=...
```

## Uninstalling the Chart

```bash
helm delete mysql
```

The `PersistentVolumeClaim` created by the StatefulSet is kept and has to be deleted separately.

## Configuration

| Parameter | Description | Type | Default |
|-----|------|---------|-------------|
| `auth.existingSecret` | Existing Secret with the root and user passwords. When set, the chart creates no Secret | string | `nil` |
| `auth.password` | User's password, used only without `existingSecret` | string | `nil` |
| `auth.passwordKey` | Key holding the user's password | string | `"MYSQL_PASSWORD"` |
| `auth.rootPassword` | Root password, used only without `existingSecret` | string | `nil` |
| `auth.rootPasswordKey` | Key holding the root password | string | `"MYSQL_ROOT_PASSWORD"` |
| `config` | Extra options for the `[mysqld]` section | string | `"innodb_buffer_pool_size=256M\n"` |
| `database` | Database created on the first start. Changing it later has no effect | string | `"app"` |
| `image.pullPolicy` | MySQL image pull policy | string | `"IfNotPresent"` |
| `image.repository` | MySQL image repository | string | `"mysql"` |
| `image.tag` | MySQL image tag | string | `"9.7.4"` |
| `nodeSelector` | Node selector for the MySQL pod | object | `{}` |
| `persistentVolume.size` | Persistent volume size | string | `"10Gi"` |
| `persistentVolume.storageClass` | Storage class, empty uses the cluster's default | string | `nil` |
| `resources` | CPU/Memory resource requests/limits | object | `{}` |
| `tolerations` | Tolerations for the MySQL pod | list | `[]` |
| `username` | User created on the first start with full access to `database`. Changing it later has no effect | string | `"app"` |

## Authentication

Set `auth.existingSecret` to a Secret holding the root password under `auth.rootPasswordKey` and the user's password under `auth.passwordKey`. The chart then creates no Secret of its own, so the passwords have a single owner (for example External Secrets). Without it, set `auth.rootPassword` and `auth.password`.

The database, user and passwords are applied on the first start only, when the data directory is initialized. Change them with SQL afterwards.

## Persistence

Data is kept on a `PersistentVolumeClaim` sized by `persistentVolume.size`. MySQL's data directory is a `data` subdirectory of the volume, because a new ext4 volume holds `lost+found` and MySQL only initializes an empty directory.
