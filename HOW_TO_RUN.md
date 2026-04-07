# 🎯 CARA MENJALANKAN PIPELINE - STEP BY STEP

## ⏱️ Total waktu: ~10 menit

---

## STEP 1: Login ke OpenShift (jika belum)

### Di Terminal:
```bash
oc login --token=YOUR_TOKEN --server=YOUR_OPENSHIFT_SERVER
```

**Cara dapat TOKEN:**
1. Buka OpenShift Web Console
2. Klik **User** (kanan atas) → **Copy login command**
3. Paste di terminal

**Contoh:**
```bash
oc login --token=sha256~abcdef123456 --server=https://api.sandbox.openshift.com:6443
```

---

## STEP 2: Buat Project/Namespace

### Opsi A: Buat baru
```bash
oc new-project tekton-pipeline
```

### Opsi B: Gunakan yang sudah ada
```bash
oc project tekton-pipeline
```

✅ **Konfirmasi:** Anda akan melihat output seperti:
```
Now using project "tekton-pipeline" on server "..."
```

---

## STEP 3: Buat PVC (PersistentVolumeClaim)

### Cara 1: Menggunakan file (recommended)
```bash
oc apply -f .tekton/pvc.yml
```

**Atau**

### Cara 2: Menggunakan command langsung
```bash
oc create pvc oc-lab-pvc \
  --size=1Gi \
  --storageclass=skills-network-learner \
  --access-modes=ReadWriteOnce
```

✅ **Verifikasi PVC dibuat:**
```bash
oc get pvc
```

Output yang diharapkan:
```
NAME         STATUS    VOLUME   CAPACITY   ACCESS MODES
oc-lab-pvc   Pending   -        1Gi        RWO
```

(Status "Pending" adalah normal, akan berubah "Bound" saat digunakan)

---

## STEP 4: Install Tekton Tasks

```bash
oc apply -f .tekton/tasks.yml
```

✅ **Verifikasi semua tasks terinstall:**
```bash
tkn task list
```

Output yang diharapkan:
```
NAME              DESCRIPTION   AGE
buildah-build                   X seconds ago
cleanup                         X seconds ago
flake8-linting                  X seconds ago
git-clone                       X seconds ago
nose-tests                      X seconds ago
```

---

## STEP 5: Buat Pipeline

```bash
oc apply -f .tekton/pipeline.yml
```

✅ **Verifikasi pipeline dibuat:**
```bash
tkn pipeline list
```

Output yang diharapkan:
```
NAME            AGE
ci-cd-pipeline  X seconds ago
```

---

## STEP 6: JALANKAN PIPELINE ⚡

```bash
oc apply -f .tekton/pipeline-run.yml
```

✅ **Output:**
```
pipelinerun.tekton.dev/ci-cd-pipeline-run created
```

---

## STEP 7: MONITOR EXECUTION 👀

### CARA 1: Live Logs (RECOMMENDED)
```bash
tkn pipelinerun logs -f
```

Ini akan menampilkan logs real-time seperti:
```
[cleanup : cleanup] Cleaning up workspace...
[cleanup : cleanup] Cleanup completed

[git-clone : clone] Cloning into '/workspace/output'...
[git-clone : clone] Cloning...

[flake8-linting : lint] Running flake8...
[flake8-linting : lint] 0 E902

[nose-tests : test] Running nose tests...
[nose-tests : test] Ran 0 tests
[nose-tests : test] OK

[buildah-build : build] Building container image...
[buildah-build : build] Image build completed

[oc-deploy] Deployment created/updated successfully
```

**Tekan Ctrl+C untuk exit**

---

### CARA 2: Check Status (tanpa logs)
```bash
tkn pipelinerun describe ci-cd-pipeline-run
```

Output:
```
Name:        ci-cd-pipeline-run
Namespace:   tekton-pipeline
Status:      Succeeded ✓

TASKRUNS
NAME                             STARTED   DURATION   STATUS
ci-cd-pipeline-run-cleanup-xxx   5s ago    3s         Succeeded ✓
ci-cd-pipeline-run-git-clone-xx  8s ago    10s        Succeeded ✓
ci-cd-pipeline-run-flake8-xxx    18s ago   8s         Succeeded ✓
ci-cd-pipeline-run-nose-xxx      26s ago   5s         Succeeded ✓
ci-cd-pipeline-run-buildah-xxx   31s ago   25s        Succeeded ✓
ci-cd-pipeline-run-deploy-xxx    56s ago   3s         Succeeded ✓
```

---

### CARA 3: List semua PipelineRuns
```bash
tkn pipelinerun list
```

Output:
```
NAME                   STARTED      DURATION   STATUS
ci-cd-pipeline-run     5 minutes ago 1m34s      Succeeded ✓
```

---

### CARA 4: Lihat logs task spesifik
```bash
# Cleanup logs
tkn pipelinerun logs ci-cd-pipeline-run -t cleanup

# Git clone logs
tkn pipelinerun logs ci-cd-pipeline-run -t git-clone

# Flake8 logs
tkn pipelinerun logs ci-cd-pipeline-run -t flake8-linting

# Tests logs
tkn pipelinerun logs ci-cd-pipeline-run -t nose-tests

# Build logs
tkn pipelinerun logs ci-cd-pipeline-run -t buildah-build

# Deploy logs
tkn pipelinerun logs ci-cd-pipeline-run -t oc-deploy
```

---

## 🎉 PIPELINE SELESAI!

### Ketika BERHASIL, Anda akan melihat:

✅ **Di Terminal:**
```
[oc-deploy] Deployment created/updated successfully
```

✅ **Status:**
```
Status: Succeeded
```

✅ **Semua tasks completed:**
```
cleanup         ✓ Succeeded
git-clone      ✓ Succeeded
flake8-linting ✓ Succeeded
nose-tests     ✓ Succeeded
buildah-build  ✓ Succeeded
oc-deploy      ✓ Succeeded
```

---

## ✓ VERIFIKASI DEPLOYMENT BERHASIL

```bash
# Cek deployment yang dibuat
oc get deployments

# Output diharapkan:
# NAME       READY   UP-TO-DATE   AVAILABLE
# ci-cd-app  1/1     1            1

# Cek pods
oc get pods

# Output diharapkan:
# NAME                        READY   STATUS    RESTARTS
# ci-cd-app-xxxxxxxxxxxxx-xxx 1/1     Running   0
```

---

## 🔄 JIKA INGIN JALANKAN ULANG

```bash
# Delete yang lama
oc delete pipelinerun ci-cd-pipeline-run

# Jalankan lagi
oc apply -f .tekton/pipeline-run.yml

# Monitor
tkn pipelinerun logs -f
```

---

## ❌ JIKA TERJADI ERROR

### Error 1: "pipelinerun logs: command not found"
**Solusi:** Install tkn CLI
```bash
# macOS
brew install tektoncd-cli

# Linux
curl -LO https://github.com/tektoncd/cli/releases/latest/download/tkn_linux_x86_64.tar.gz
tar xzf tkn_linux_x86_64.tar.gz
sudo mv tkn /usr/local/bin/

# Windows
choco install tekton-cli
```

---

### Error 2: "PVC oc-lab-pvc not found"
**Solusi:** Buat PVC terlebih dahulu
```bash
oc apply -f .tekton/pvc.yml
```

---

### Error 3: Task gagal "image pull error"
**Solusi:** Tunggu atau gunakan image yang lebih kecil
```bash
# Cek pod yang error
oc describe pod <pod-name>

# Jalankan ulang setelah beberapa saat
oc delete pipelinerun ci-cd-pipeline-run
oc apply -f .tekton/pipeline-run.yml
```

---

## 📸 UNTUK SCREENSHOT

Ambil screenshot:
1. Output dari `tkn pipelinerun logs -f` saat berjalan
2. Output dari `tkn pipelinerun describe ci-cd-pipeline-run` setelah selesai
3. OpenShift Web Console → Pipelines → PipelineRuns (lihat status)
4. Output dari `oc get deployments` menunjukkan app deployed

---

## 💡 TIPS & TRICKS

### Lihat real-time tanpa tkn
```bash
oc get pipelinerun -w
```

### Autohighlight logs dengan warna
```bash
tkn pipelinerun logs ci-cd-pipeline-run -f --all
```

### Clear terminal dan jalankan ulang
```bash
clear
oc apply -f .tekton/pipeline-run.yml && tkn pipelinerun logs -f
```

### Combine commands
```bash
# Setup + run + monitor dalam satu baris
oc apply -f .tekton/pvc.yml && \
oc apply -f .tekton/tasks.yml && \
oc apply -f .tekton/pipeline.yml && \
oc apply -f .tekton/pipeline-run.yml && \
tkn pipelinerun logs -f
```

---

## 🎯 RINGKASAN PERINTAH PENTING

```bash
# Setup
oc new-project tekton-pipeline
oc apply -f .tekton/pvc.yml
oc apply -f .tekton/tasks.yml
oc apply -f .tekton/pipeline.yml

# Run
oc apply -f .tekton/pipeline-run.yml

# Monitor (pilih salah satu)
tkn pipelinerun logs -f              # Live logs
tkn pipelinerun describe ci-cd-pipeline-run  # Status
tkn pipelinerun list                  # List all

# Verifikasi deployment
oc get deployments
oc get pods
```

---

Good luck! Pipeline siap dijalankan! 🚀
