# ⚠️ PENTING: Dimana Harus Dijalankan?

## ❌ JANGAN di Windows/Local Machine:

```bash
# Ini TIDAK akan bekerja di Windows Anda:
kubectl apply -f .tekton/tasks.yml
```

**Error Anda:** 
```
failed to download openapi: Get "http://localhost:8080/openapi/v2?timeout=32s": 
dial tcp [::1]:8080: connectex: No connection could be made
```

**Alasannya:** Tidak ada OpenShift/Kubernetes cluster di mesin lokal Anda!

---

## ✅ HARUS di OpenShift Lab Environment:

### ADA 3 CARA:

---

## CARA 1: Gunakan OpenShift Web Terminal (PALING MUDAH)

1. Login ke **OpenShift Web Console**
2. Klik **Terminal** (icon >_ di atas kanan)
3. Otomatis sudah login ke cluster!
4. Jalankan commands:

```bash
# Verify connection
oc cluster-info

# Create project
oc new-project tekton-pipeline

# Apply files
oc apply -f .tekton/pvc.yml
oc apply -f .tekton/tasks.yml
oc apply -f .tekton/pipeline.yml
oc apply -f .tekton/pipeline-run.yml

# Monitor
tkn pipelinerun logs -f
```

---

## CARA 2: SSH/Connect ke OpenShift Node

1. Dapatkan akses SSH ke lab environment
2. Login dengan:
```bash
oc login --token=YOUR_TOKEN --server=YOUR_OPENSHIFT_SERVER
```

3. Jalankan commands

---

## CARA 3: VSCode Remote SSH (Optional)

1. Install **Remote - SSH** extension di VSCode
2. Connect ke lab environment
3. Open folder project
4. Jalankan commands di terminal VSCode

---

## 🎯 RINGKASNYA:

| Lokasi | Status |
|--------|--------|
| Windows/Local PC | ❌ Tidak bisa, tidak ada cluster |
| OpenShift Lab | ✅ Bisa! Gunakan Web Terminal |
| SSH ke Lab | ✅ Bisa! Login dulu dengan oc |

---

## 📝 TODO:

1. ✅ Semua file Tekton sudah di-push ke GitHub
2. ⏳ Masuk ke OpenShift Web Console
3. ⏳ Buka Web Terminal
4. ⏳ Clone repository atau navigate ke project folder
5. ⏳ Run commands dari `RUN_NOW.md`

---

## 💡 UNTUK MENDAPATKAN TOKEN:

1. Buka OpenShift Web Console
2. Klik **User** (kanan atas)
3. Klik **Copy login command**
4. Salin token dan server URL
5. Gunakan untuk login di terminal

---

**Key Point:** Tekton pipeline HARUS dijalankan di OpenShift cluster, bukan di lokal! 🚀
