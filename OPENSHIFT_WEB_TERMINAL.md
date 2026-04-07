# 🌐 CARA PAKAI OpenShift Web Terminal

## STEP 1: Buka OpenShift Web Console

1. Buka browser
2. Masuk ke OpenShift Web Console (diberikan di lab)
3. Login dengan credentials yang diberikan

---

## STEP 2: Buka Web Terminal

Lihat screenshot:

```
┌─────────────────────────────────────────────┐
│  OpenShift Web Console                      │
├─────────────────────────────────────────────┤
│                                             │
│  [☰ Menu] [Search] [?] [⚙️] [👤 User]      │  ← Klik icon >_
│                                             │
│  Projects | Workloads | Networking | ...   │
│                                             │
│                                             │
│                                             │
└─────────────────────────────────────────────┘
```

**Cari dan klik icon `>_` (Terminal) di atas kanan dashboard**

---

## STEP 3: Terminal akan terbuka

```
┌────────────────────────────────────────┐
│ OpenShift Web Terminal                  │
├────────────────────────────────────────┤
│                                         │
│ $ _                                     │
│                                         │
│                                         │
└────────────────────────────────────────┘
```

---

## STEP 4: Copy Repository (optional, jika belum ada)

Jika project folder belum ada di lab:

```bash
# Clone repository
git clone https://github.com/Pangpang0255/ci-cd-final-project.git

# Masuk ke folder
cd ci-cd-final-project
```

Atau jika sudah ada:

```bash
cd ci-cd-final-project
```

---

## STEP 5: Jalankan Commands (Copy-Paste)

```bash
# Verify connected
oc cluster-info

# Create project
oc new-project tekton-pipeline

# Apply PVC
oc apply -f .tekton/pvc.yml

# Apply Tasks
oc apply -f .tekton/tasks.yml

# Apply Pipeline
oc apply -f .tekton/pipeline.yml

# Run Pipeline
oc apply -f .tekton/pipeline-run.yml
```

---

## STEP 6: Monitor Pipeline

```bash
# Live logs (recommended)
tkn pipelinerun logs -f
```

Akan tampil seperti:

```
[cleanup : cleanup] Cleaning up workspace...
[cleanup : cleanup] Cleanup completed

[git-clone : clone] Cloning into '/workspace/output'...

[flake8-linting : lint] Running flake8...

[nose-tests : test] Ran 0 tests
[nose-tests : test] OK

[buildah-build : build] Building container image...

[oc-deploy] Deployment created/updated successfully

✓ PipelineRun succeeded
```

---

## ✓ SELESAI!

Jika melihat "✓ PipelineRun succeeded" berarti pipeline berhasil! 🎉

---

## 💡 TIPS WEB TERMINAL

1. **Copy-Paste:** 
   - Copy: Ctrl+C (select text)
   - Paste: Ctrl+Shift+V (atau klik kanan → Paste)

2. **Clear screen:**
   ```bash
   clear
   ```

3. **Lihat current directory:**
   ```bash
   pwd
   ```

4. **List files:**
   ```bash
   ls -la
   ```

5. **Exit terminal:** 
   - Klik X atau tutup tab

---

## 🎯 QUICK COMMANDS COPY-PASTE READY:

```bash
oc new-project tekton-pipeline && oc apply -f .tekton/pvc.yml && oc apply -f .tekton/tasks.yml && oc apply -f .tekton/pipeline.yml && oc apply -f .tekton/pipeline-run.yml && tkn pipelinerun logs -f
```

**Paste semua sekaligus, otomatis akan berjalan step by step!**

---

**That's it! Pipeline siap dijalankan dari Web Terminal! 🚀**
