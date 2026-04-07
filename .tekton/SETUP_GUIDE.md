# Petunjuk Setup Tekton Pipeline di OpenShift Lab

## Langkah 1: Login ke OpenShift Cluster

```bash
# Dapatkan login command dari OpenShift Web Console
# Salin dari Console > User > Copy login command
oc login --token=<your-token> --server=<openshift-server-url>
```

## Langkah 2: Buat Namespace (jika belum ada)

```bash
oc new-project tekton-pipeline
```

## Langkah 3: Instalasi Tekton Pipelines (jika belum ada)

```bash
# Operator Tekton biasanya sudah terinstall di OpenShift
# Jika belum, install melalui OpenShift Administrator Console
```

## Langkah 4: Buat PersistentVolumeClaim

```bash
oc apply -f .tekton/pvc.yml
```

Atau menggunakan oc command:

```bash
oc create pvc oc-lab-pvc \
  --size=1Gi \
  --storageclass=skills-network-learner \
  --access-modes=ReadWriteOnce
```

## Langkah 5: Install Tekton Tasks

```bash
oc apply -f .tekton/tasks.yml
```

Verifikasi tasks sudah terinstall:

```bash
tkn task list
```

## Langkah 6: Buat Pipeline

```bash
oc apply -f .tekton/pipeline.yml
```

Verifikasi pipeline:

```bash
tkn pipeline list
```

## Langkah 7: Jalankan Pipeline

```bash
oc apply -f .tekton/pipeline-run.yml
```

Atau menggunakan tkn CLI:

```bash
tkn pipeline start ci-cd-pipeline \
  --param=repository-url=https://github.com/Pangpang0255/ci-cd-final-project.git \
  --param=app-name=ci-cd-app \
  --param=build-image=image-registry.openshift-image-registry.svc:5000/default/ci-cd-app:latest \
  --workspace=name=output,claimName=oc-lab-pvc \
  --showlog
```

## Langkah 8: Monitor Pipeline Execution

```bash
# Lihat status PipelineRun
oc get pipelinerun

# Lihat logs PipelineRun
tkn pipelinerun logs ci-cd-pipeline-run -f

# Lihat detail PipelineRun
tkn pipelinerun describe ci-cd-pipeline-run
```

## Langkah 9: Verifikasi Deployment

```bash
# Cek deployment yang dibuat
oc get deployments

# Cek pods
oc get pods

# Cek service
oc get svc

# Akses aplikasi (jika sudah expose)
oc port-forward svc/ci-cd-app 8080:5000
```

## Troubleshooting

### PipelineRun Gagal
```bash
# Lihat detail error
tkn pipelinerun describe <pipelinerun-name> -v

# Lihat logs task yang gagal
tkn pipelinerun logs <pipelinerun-name> -t <task-name>
```

### Memory/Resource Issues
```bash
# Tambah resource limits pada task jika diperlukan
# Edit file tasks.yml dan tambahkan:
# resources:
#   limits:
#     memory: "1Gi"
#     cpu: "500m"
```

### Image Registry Issues
```bash
# Jika push image gagal, periksa registry credentials
oc get secrets
oc describe is ci-cd-app  # Check ImageStream
```

## File-file Tekton

1. **tasks.yml** - Definisi semua tasks (cleanup, git-clone, flake8, nose, buildah)
2. **pvc.yml** - PersistentVolumeClaim configuration
3. **pipeline.yml** - Pipeline definition dengan semua steps
4. **pipeline-run.yml** - PipelineRun untuk menjalankan pipeline

## Expected Pipeline Execution Order

1. cleanup - Bersihkan workspace
2. git-clone - Clone repository
3. flake8-linting - Linting dengan flake8
4. nose-tests - Menjalankan tests
5. buildah-build - Build container image
6. oc-deploy - Deploy ke OpenShift cluster
