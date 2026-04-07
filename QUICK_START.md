# ⚡ QUICK START: Jalankan Pipeline dalam 5 Menit

## ✅ CHECKLIST SEBELUM JALANKAN

- [ ] Anda sudah login ke OpenShift Web Console
- [ ] Anda memiliki `oc` dan `tkn` CLI tools
- [ ] PVC `oc-lab-pvc` sudah visible di OpenShift Console
- [ ] Anda berada di direktori project root
- [ ] Git repository sudah ter-push ke GitHub

---

## 🏃 QUICK START (Copy-Paste Commands)

```bash
# 1. Login (jika belum)
oc login --token=YOUR_TOKEN --server=YOUR_OPENSHIFT_SERVER

# 2. Create namespace
oc new-project tekton-pipeline

# 3. Apply PVC
oc apply -f .tekton/pvc.yml

# 4. Apply Tasks
oc apply -f .tekton/tasks.yml

# 5. Apply Pipeline
oc apply -f .tekton/pipeline.yml

# 6. Run Pipeline
oc apply -f .tekton/pipeline-run.yml

# 7. Monitor (Real-time logs)
tkn pipelinerun logs -f
```

---

## 📊 DURING EXECUTION

### Terminal: Monitor dengan tkn
```bash
# Option 1: Live logs (recommended)
tkn pipelinerun logs -f

# Option 2: Describe status
tkn pipelinerun describe ci-cd-pipeline-run

# Option 3: List all runs
tkn pipelinerun list
```

### Web Console: Monitor dengan OpenShift UI
1. Go to **Pipelines** → **PipelineRuns**
2. Click **ci-cd-pipeline-run**
3. Watch the tasks execute
4. Click each task to see detailed logs

---

## ✓ EXPECTED RESULT

```
✓ cleanup         ✓ Completed
✓ git-clone      ✓ Completed  
✓ flake8-linting ✓ Completed
✓ nose-tests     ✓ Completed
✓ buildah-build  ✓ Completed
✓ oc-deploy      ✓ Completed

Overall: SUCCESS 🎉
```

---

## 🔍 VERIFY DEPLOYMENT

```bash
# Check deployment
oc get deployments

# Check pods
oc get pods

# Check service
oc get svc

# Port forward to access app
oc port-forward svc/ci-cd-app 8080:5000
# Then visit: http://localhost:8080
```

---

## 📁 FILES REFERENCE

| File | Purpose |
|------|---------|
| `.tekton/tasks.yml` | Definisi semua Tekton tasks |
| `.tekton/pvc.yml` | PersistentVolumeClaim config |
| `.tekton/pipeline.yml` | Pipeline definition |
| `.tekton/pipeline-run.yml` | Pipeline run instance |
| `PIPELINE_EXECUTION_GUIDE.md` | Panduan lengkap (detailed) |
| `run-pipeline.sh` | Automated setup script |

---

## 💡 TIPS

1. **Jika run gagal**: Delete run dan jalankan ulang
   ```bash
   oc delete pipelinerun ci-cd-pipeline-run
   oc apply -f .tekton/pipeline-run.yml
   ```

2. **Lihat error task spesifik**:
   ```bash
   tkn pipelinerun logs ci-cd-pipeline-run -t TASK_NAME
   ```

3. **Cleanup semua resources**:
   ```bash
   oc delete -f .tekton/
   oc delete project tekton-pipeline
   ```

4. **Custom run dengan parameters**:
   ```bash
   tkn pipeline start ci-cd-pipeline \
     --param repository-url=YOUR_REPO \
     --param app-name=YOUR_APP \
     --workspace=name=output,claimName=oc-lab-pvc \
     --showlog
   ```

---

Good luck! Semoga pipeline berjalan lancar! 🚀
