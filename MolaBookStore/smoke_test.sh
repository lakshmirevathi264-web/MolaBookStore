#!/usr/bin/env bash
set -euo pipefail
BASE=${1:-http://localhost:8080/MolaBookStore}
COOKIEFILE=/tmp/mola_smoke_cookies.txt

TEST_USER="smoketest_user_$RANDOM"
TEST_PW='password1'

echo "Smoke test using user: $TEST_USER"
rm -f "$COOKIEFILE" /tmp/mola_smoke_headers.txt || true

echo "1) Signup"
curl -i -sS -c "$COOKIEFILE" -X POST "$BASE/signup" -d "username=$TEST_USER&password=$TEST_PW" -D /tmp/mola_smoke_headers.txt || true
sed -n '1,120p' /tmp/mola_smoke_headers.txt || true

echo "\n2) Login"
curl -i -sS -c "$COOKIEFILE" -b "$COOKIEFILE" -X POST "$BASE/login" -d "username=$TEST_USER&password=$TEST_PW" -D /tmp/mola_smoke_headers.txt || true
sed -n '1,120p' /tmp/mola_smoke_headers.txt || true

echo "\n3) Add to cart (bookId=1)"
curl -i -sS -b "$COOKIEFILE" -H 'X-Requested-With: XMLHttpRequest' -X POST "$BASE/addToCart" -d 'bookId=1' || true

echo "\n4) View cart"
curl -i -sS -b "$COOKIEFILE" "$BASE/cart" | sed -n '1,200p' || true

echo "\n5) Payment"
curl -i -sS -b "$COOKIEFILE" -X POST "$BASE/payment" -D /tmp/mola_smoke_headers.txt || true
sed -n '1,120p' /tmp/mola_smoke_headers.txt || true

echo "Smoke test finished."
