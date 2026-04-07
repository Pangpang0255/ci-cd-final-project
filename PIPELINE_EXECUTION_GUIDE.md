# PANDUAN LENGKAP: Menjalankan Tekton Pipeline di OpenShift Lab

## 📋 Persiapan

Pastikan Anda sudah:
1. ✅ Login ke OpenShift Web Console
2. ✅ Memiliki akses CLI (oc dan tkn commands)
3. ✅ PVC `oc-lab-pvc` sudah ter-create (1GB, storage class: skills-network-learner)

---

## 🚀 CARA MENJALANKAN PIPELINE

### Opsi A: Menggunakan oc commands secara manual

**Langkah 1: Login ke OpenShift**
```bash
oc login --token=YOUR_TOKEN --server=YOUR_OPENSHIFT_URL
```

**Langkah 2: Buat/Switch ke namespace**
```bash
oc new-project tekton-pipeline
# atau jika sudah ada:
oc project tekton-pipeline
```

**Langkah 3: Buat PVC (jika belum ada)**
```bash
oc apply -f .tekton/pvc.yml
# atau langsung dengan oc command:
oc create pvc oc-lab-pvc --size=1Gi --storageclass=skills-network-learner
```

**Langkah 4: Install Tasks**
```bash
oc apply -f .tekton/tasks.yml
```

Verifikasi tasks terinstall:
```bash
tkn task list
```

Output yang diharapkan:
```
NAME              DESCRIPTION   AGE
cleanup                         XX seconds ago
git-clone                       XX seconds ago
flake8-linting                  XX seconds ago
nose-tests                      XX seconds ago
buildah-build                   XX seconds ago
```

**Langkah 5: Buat Pipeline**
```bash
oc apply -f .tekton/pipeline.yml
```

Verifikasi pipeline:
```bash
tkn pipeline list
```

Output:
```
NAME            AGE
ci-cd-pipeline  XX seconds ago
```

**Langkah 6: Jalankan Pipeline**
```bash
oc apply -f .tekton/pipeline-run.yml
```

---

### Opsi B: Menggunakan Script (jika di Linux/Mac)

```bash
chmod +x run-pipeline.sh
./run-pipeline.sh
```

---

## 📊 MONITOR PIPELINE EXECUTION

### Cara 1: Dengan tkn CLI (Recommended)

```bash
# Lihat semua PipelineRuns
tkn pipelinerun list

# Monitor logs secara real-time
tkn pipelinerun logs -f

# Atau spesifik run tertentu
tkn pipelinerun logs ci-cd-pipeline-run -f

# Lihat progress secara visual
tkn pipelinerun describe ci-cd-pipeline-run

# Lihat logs task tertentu
tkn pipelinerun logs ci-cd-pipeline-run -t cleanup
tkn pipelinerun logs ci-cd-pipeline-run -t git-clone
tkn pipelinerun logs ci-cd-pipeline-run -t flake8-linting
tkn pipelinerun logs ci-cd-pipeline-run -t nose-tests
tkn pipelinerun logs ci-cd-pipeline-run -t buildah-build
```

### Cara 2: Dengan OpenShift Web Console

1. Login ke OpenShift Web Console
2. Navigasi ke **Pipelines** → **PipelineRuns**
3. Klik pada `ci-cd-pipeline-run`
4. Lihat status masing-masing task
5. Klik task untuk melihat logs detail

### Cara 3: Dengan kubectl/oc

```bash
# Lihat semua pods yang dijalankan oleh pipeline
oc get pods

# Lihat detail pod tertentu
oc describe pod <pod-name>

# Lihat logs pod
oc logs <pod-name>

# Watch pod status
watch oc get pods
```

---

## ✅ EXPECTED PIPELINE EXECUTION

Pipeline akan berjalan dengan urutan berikut:

```
START
  ↓
1. cleanup (⏱ ~5s)
  ├─ Membersihkan workspace
  ├─ rm -rf /workspace/output/*
  └─ Status: ✓ Completed
  ↓
2. git-clone (⏱ ~10s)
  ├─ Clone repository
  ├─ URL: https://github.com/Pangpang0255/ci-cd-final-project.git
  ├─ Branch: main
  └─ Status: ✓ Completed
  ↓
3. flake8-linting (⏱ ~15s)
  ├─ Install flake8
  ├─ Lint src folder
  └─ Status: ✓ Completed
  ↓
4. nose-tests (⏱ ~10s)
  ├─ Install nose & pytest
  ├─ Run tests
  └─ Status: ✓ Completed (OK - 0 tests)
  ↓
5. buildah-build (⏱ ~30s)
  ├─ Build container image
  ├─ Image: image-registry.openshift-image-registry.svc:5000/default/ci-cd-app:latest
  └─ Status: ✓ Completed
  ↓
6. oc-deploy (⏱ ~5s)
  ├─ Create deployment
  ├─ Deploy app: ci-cd-app
  └─ Status: ✓ Completed
  ↓
END (✓ SUCCESS)
```

**Total durasi: ~75 detik**

---

## 🐛 TROUBLESHOOTING

### Problem: PVC Status masih "Pending"
```bash
# Cek apakah ada PersistentVolume yang sesuai
oc get pv

# Jika tidak ada, cek storage class
oc get storageclass skills-network-learner
```

### Problem: Task gagal dengan image pull error
```bash
# Cek image availability
oc describe pod <pod-name>

# Solusi: Gunakan image yang lebih kecil atau dari registry yang accessible
```

### Problem: Pipeline run stuck/hanging
```bash
# Cek status pod
oc get pods -n tekton-pipeline

# Lihat events
oc describe pipelinerun ci-cd-pipeline-run

# Jika perlu, delete dan jalankan ulang
oc delete pipelinerun ci-cd-pipeline-run
oc apply -f .tekton/pipeline-run.yml
```

### Problem: BuildAh build error
```bash
# BuildAh butuh privileged container
# Pastikan security context sudah diset ke privileged: true

# Atau gunakan task buildah yang sudah ada di cluster
tkn task list | grep build
```

---

## 📸 EXPECTED OUTPUT SCREENSHOTS

### 1. PipelineRun Status (Web Console)
```
Status: Succeeded ✓
Reason: PipelineRunCompleted
Message: All tasks completed successfully
```

### 2. PipelineRun Logs
```
cleanup
  ✓ cleanup step
  Cleaning up workspace...
  Cleanup completed

git-clone
  ✓ clone step
  Cloning into '/workspace/output'...

flake8-linting
  ✓ lint step
  Running flake8...
  0 E9
  0 F63
  ...

nose-tests
  ✓ test step
  Running nose tests...
  Ran 0 tests
  OK

buildah-build
  ✓ build step
  Building container image...
  Image build completed

oc-deploy
  ✓ oc deploy
  Deployment created/updated successfully
```

---

## 🔍 VERIFIKASI HASIL

Setelah pipeline selesai:

```bash
# Cek deployment yang dibuat
oc get deployments
# Expected: ci-cd-app

# Cek pods
oc get pods
# Expected: ci-cd-app-xxxxx pods running

# Cek image yang di-build
oc get imagestream
# Expected: ci-cd-app

# Test deployment
oc port-forward deployment/ci-cd-app 8080:5000
# Akses: http://localhost:8080
```

---

## 📝 NEXT STEPS

1. ✅ Pipeline setup complete
2. ✅ Deploy ke OpenShift
3. ⏳ Test application
4. ⏳ Monitor and update as needed

Good luck! 🚀
