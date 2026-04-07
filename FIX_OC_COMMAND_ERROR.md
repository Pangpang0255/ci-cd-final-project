# ⚠️ PENTING: JANGAN JALANKAN DI WINDOWS/LOCAL PC

## ❌ ERROR ANDA:

```
oc : The term 'oc' is not recognized as the name of a cmdlet
```

**Penyebab:** `oc` command tidak terinstall di Windows Anda

---

## 🎯 SOLUSI: GUNAKAN OPENSHIFT WEB TERMINAL

### Anda memiliki 2 pilihan:

---

## PILIHAN 1: OpenShift Web Terminal (PALING MUDAH) ⭐

**Ini yang sebaiknya Anda gunakan!**

### Step-by-step:

1. **Buka OpenShift Web Console**
   - Cari link OpenShift Lab yang diberikan
   - Buka di browser

2. **Login**
   - Masukkan username & password yang diberikan

3. **Cari Terminal**
   - Lihat di atas kanan dashboard
   - Ada icon `>_` atau `Terminal`
   - Klik itu

4. **Terminal akan terbuka**

   ```
   $ _
   ```

5. **Sekarang Anda bisa copy-paste commands:**
   ```bash
   oc new-project tekton-pipeline
   oc apply -f .tekton/pvc.yml
   oc apply -f .tekton/tasks.yml
   oc apply -f .tekton/pipeline.yml
   oc apply -f .tekton/pipeline-run.yml
   tkn pipelinerun logs -f
   ```

✅ **Di Web Terminal, semuanya sudah siap dan terkoneksi!**

---

## PILIHAN 2: Install oc CLI di Windows (Complicated)

Jika Anda ingin pakai local PC:

```powershell
# Download oc CLI
# 1. Buka: https://github.com/openshift/oc/releases
# 2. Download oc-windows-amd64.zip
# 3. Extract ke C:\Program Files\oc\
# 4. Add ke PATH environment variable
# 5. Restart terminal
# 6. Login dengan:
#    oc login --token=YOUR_TOKEN --server=YOUR_SERVER
```

**TAPI INI RIBET! Better use Web Terminal!**

---

## 📸 DIMANA WEB TERMINAL?

Lihat gambar berikut (approximate):

```
┌──────────────────────────────────────────────────────┐
│ OpenShift Console                                     │
├──────────────────────────────────────────────────────┤
│                                                       │
│ [Menu] [Search] [...] [?] [⚙️] [👤] [>_] ← CLICK!   │
│                                                       │
│ Project | Networking | Workloads | Storage | ...     │
│                                                       │
│ (Dashboard content)                                   │
│                                                       │
└──────────────────────────────────────────────────────┘
```

**Cari icon `>_` atau `Terminal` di kanan atas**

---

## ✅ RECOMMENDED FLOW:

```
1. Windows PC (sekarang)
   ├─ ✅ Edit files
   ├─ ✅ Commit & push ke GitHub
   └─ ✅ Sudah selesai

2. OpenShift Lab Environment
   ├─ Buka Web Terminal
   ├─ Clone repository: git clone https://github.com/Pangpang0255/ci-cd-final-project.git
   ├─ cd ci-cd-final-project
   └─ Paste commands dari RUN_NOW.md

3. Screenshot hasil
   ├─ Pipeline logs
   ├─ Final status
   └─ Deployment info
```

---

## 🎯 NEXT STEPS:

### Di Windows PC (Apa yang sudah Anda lakukan):

- ✅ Setup GitHub Actions workflow
- ✅ Create Tekton pipeline files
- ✅ Push semuanya ke GitHub

### Di OpenShift Lab (Apa yang harus dilakukan):

- ⏳ Buka Web Terminal
- ⏳ Clone/navigate ke project folder
- ⏳ Run commands dari RUN_NOW.md
- ⏳ Screenshot hasilnya

---

## 💡 KEY POINT:

```
╔═══════════════════════════════════════════════════════╗
║ Windows/Local PC:                                     ║
║ ├─ Edit & push code ✅                                ║
║ └─ Jangan jalankan oc/kubectl ❌                       ║
║                                                       ║
║ OpenShift Lab:                                        ║
║ ├─ Gunakan Web Terminal ✅                             ║
║ └─ Di sini baru bisa pakai oc commands ✅              ║
╚═══════════════════════════════════════════════════════╝
```

---

## ⏭️ TUNGGU APA LAGI?

1. **Masuk ke OpenShift Lab**
2. **Buka Web Terminal**
3. **Paste commands dari RUN_NOW.md**
4. **Screenshot hasilnya**

**Mudah kan?** 🚀

Semua file Tekton sudah siap di GitHub!
