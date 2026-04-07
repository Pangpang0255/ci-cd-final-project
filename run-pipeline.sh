#!/bin/bash

# Script untuk setup dan menjalankan Tekton Pipeline di OpenShift

set -e  # Exit jika ada error

echo "=========================================="
echo "Tekton Pipeline Setup untuk OpenShift"
echo "=========================================="

# Warna untuk output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Check kubectl/oc connection
echo -e "${BLUE}[1/7] Verifying OpenShift connection...${NC}"
if ! oc cluster-info > /dev/null 2>&1; then
  echo -e "${YELLOW}Not connected to OpenShift cluster${NC}"
  echo "Please login first: oc login --token=<token> --server=<url>"
  exit 1
fi
echo -e "${GREEN}✓ Connected to OpenShift${NC}"

# 2. Create namespace if needed
echo -e "${BLUE}[2/7] Checking/Creating namespace...${NC}"
NAMESPACE="tekton-pipeline"
if oc get namespace $NAMESPACE 2>/dev/null; then
  echo -e "${GREEN}✓ Namespace $NAMESPACE already exists${NC}"
else
  echo "Creating namespace $NAMESPACE..."
  oc create namespace $NAMESPACE
  echo -e "${GREEN}✓ Namespace created${NC}"
fi

# 3. Switch to tekton-pipeline namespace
echo -e "${BLUE}[3/7] Switching to $NAMESPACE namespace...${NC}"
oc project $NAMESPACE
echo -e "${GREEN}✓ Switched to namespace${NC}"

# 4. Create PVC
echo -e "${BLUE}[4/7] Creating PersistentVolumeClaim...${NC}"
oc apply -f .tekton/pvc.yml
echo -e "${GREEN}✓ PVC created${NC}"

# 5. Install/Apply Tasks
echo -e "${BLUE}[5/7] Installing Tekton Tasks...${NC}"
oc apply -f .tekton/tasks.yml
echo "Tasks installed:"
echo "  - cleanup"
echo "  - git-clone"
echo "  - flake8-linting"
echo "  - nose-tests"
echo "  - buildah-build"
echo -e "${GREEN}✓ All tasks installed${NC}"

# 6. Create Pipeline
echo -e "${BLUE}[6/7] Creating Pipeline...${NC}"
oc apply -f .tekton/pipeline.yml
echo -e "${GREEN}✓ Pipeline created${NC}"

# 7. Run Pipeline
echo -e "${BLUE}[7/7] Starting Pipeline Run...${NC}"
oc apply -f .tekton/pipeline-run.yml
echo -e "${GREEN}✓ Pipeline run started${NC}"

echo ""
echo "=========================================="
echo "Pipeline Setup Complete!"
echo "=========================================="
echo ""
echo "To monitor the pipeline:"
echo "  tkn pipelinerun logs -f"
echo ""
echo "Or watch in real-time:"
echo "  watch 'tkn pipelinerun list'"
echo ""
echo "View pipeline details:"
echo "  tkn pipelinerun describe ci-cd-pipeline-run"
echo ""
