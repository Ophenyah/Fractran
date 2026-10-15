#!/usr/bin/env bash

# Usage: ./run_tests.sh p

#merci chat gpt

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR/interpreteur"
TEST_DIR="$SCRIPT_DIR/tests"
P="${1:?Usage: $0 fichier_p}"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

passed=0
failed=0
total=0

for input in "$TEST_DIR"/*.in; do
    [[ -e "$input" ]] || break

    name="${input%.in}"
    expected="${name}.out"
    test_name="${input##*/}"
    total=$((total + 1))

    if [[ ! -f "$expected" ]]; then
        echo -e "${YELLOW}[SKIP]${NC} $test_name: missing .out file"
        failed=$((failed + 1))
        continue
    fi

    actual=$(mktemp)
    error=$(mktemp)

    if (cd "$PROJECT_DIR" && dune exec Fractran "$input" "$P") \
        >"$actual" 2>"$error"; then

if diff -wB \
    <(sed 's/[[:space:]]*$//' "$expected") \
    <(sed 's/[[:space:]]*$//' "$actual") >/dev/null; then

    echo -e "${GREEN}[PASS]${NC} $test_name"
    passed=$((passed + 1))
else
    echo -e "${RED}[FAIL]${NC} $test_name"
    diff -u \
        <(sed 's/[[:space:]]*$//' "$expected") \
        <(sed 's/[[:space:]]*$//' "$actual") | sed 's/^/    /'
    failed=$((failed + 1))
fi
    else
        echo -e "${RED}[ERROR]${NC} $test_name: execution failed"
        sed 's/^/    /' "$error"
        failed=$((failed + 1))
    fi

    rm -f "$actual" "$error"
done

echo
echo "========== Summary =========="
echo "Total  : $total"
echo -e "Passed : ${GREEN}${passed}${NC}"
echo -e "Failed : ${RED}${failed}${NC}"

if (( total == 0 )); then
    echo "No tests found."
    exit 2
elif (( failed == 0 )); then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
