# 🚀 CARA RUN PIPELINE - SUPER SINGKAT

## 7 COMMAND SAJA:

```bash
# 1. Login
oc login --token=YOUR_TOKEN --server=YOUR_SERVER

# 2. Buat project
oc new-project tekton-pipeline

# 3. Buat PVC
oc apply -f .tekton/pvc.yml

# 4. Install tasks
oc apply -f .tekton/tasks.yml

# 5. Buat pipeline
oc apply -f .tekton/pipeline.yml

# 6. JALANKAN
oc apply -f .tekton/pipeline-run.yml

# 7. LIHAT HASILNYA
tkn pipelinerun logs -f
```

---

## EXPECTED OUTPUT:

```
[cleanup : cleanup] Cleaning up workspace...
[cleanup : cleanup] Cleanup completed

[git-clone : clone] Cloning...

[flake8-linting : lint] Running flake8...

[nose-tests : test] Ran 0 tests - OK

[buildah-build : build] Image build completed

[oc-deploy] Deployment created/updated successfully

✓ Pipeline Succeeded!
```

---

## ✓ VERIFIKASI:

```bash
oc get deployments     # Lihat app deployed
oc get pods           # Lihat pods running
```

---

That's it! 🎉
