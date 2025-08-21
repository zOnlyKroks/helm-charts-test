#!/bin/bash

# Test runner script for all helm charts
# This script runs helm unittest for all charts to validate common parameters

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHARTS_DIR="${SCRIPT_DIR}/charts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🧪 Running Helm Unit Tests for All Charts"
echo "=========================================="

# Check if helm-unittest plugin is installed
if ! helm plugin list | grep -q unittest; then
    echo -e "${YELLOW}⚠️  helm-unittest plugin not found. Installing...${NC}"
    helm plugin install https://github.com/helm-unittest/helm-unittest
fi

# Charts to test
CHARTS=("mongodb" "clusterpirate" "mariadb" "redis" "minio" "postgres" "valkey" "rabbitmq")

# Track results
PASSED_CHARTS=()
FAILED_CHARTS=()

for CHART in "${CHARTS[@]}"; do
    echo ""
    echo -e "${YELLOW}🔍 Testing ${CHART} chart...${NC}"
    
    CHART_PATH="${CHARTS_DIR}/${CHART}"
    
    if [ ! -d "$CHART_PATH" ]; then
        echo -e "${RED}❌ Chart directory not found: $CHART_PATH${NC}"
        FAILED_CHARTS+=("$CHART")
        continue
    fi
    
    if [ ! -d "$CHART_PATH/tests" ]; then
        echo -e "${YELLOW}⚠️  No tests directory found for $CHART${NC}"
        continue
    fi
    
    # Update dependencies first
    echo "📦 Updating dependencies for $CHART..."
    if ! helm dependency update "$CHART_PATH" >/dev/null 2>&1; then
        echo -e "${RED}❌ Failed to update dependencies for $CHART${NC}"
        FAILED_CHARTS+=("$CHART")
        continue
    fi
    
    # Run tests
    if helm unittest "$CHART_PATH"; then
        echo -e "${GREEN}✅ $CHART tests passed${NC}"
        PASSED_CHARTS+=("$CHART")
    else
        echo -e "${RED}❌ $CHART tests failed${NC}"
        FAILED_CHARTS+=("$CHART")
    fi
done

# Summary
echo ""
echo "📊 Test Summary"
echo "==============="
echo -e "${GREEN}✅ Passed: ${#PASSED_CHARTS[@]}${NC}"
if [ ${#PASSED_CHARTS[@]} -gt 0 ]; then
    for CHART in "${PASSED_CHARTS[@]}"; do
        echo -e "   ${GREEN}• $CHART${NC}"
    done
fi

echo -e "${RED}❌ Failed: ${#FAILED_CHARTS[@]}${NC}"
if [ ${#FAILED_CHARTS[@]} -gt 0 ]; then
    for CHART in "${FAILED_CHARTS[@]}"; do
        echo -e "   ${RED}• $CHART${NC}"
    done
fi

echo ""
if [ ${#FAILED_CHARTS[@]} -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}💥 Some tests failed. Check the output above for details.${NC}"
    exit 1
fi