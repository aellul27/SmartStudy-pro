SQLITE_URL=$(curl -s https://api.github.com/repos/simolus3/sqlite3.dart/releases/latest | grep "browser_download_url" | grep "sqlite3.wasm" | cut -d '"' -f 4)
DRIFT_URL=$(curl -s https://api.github.com/repos/simolus3/drift/releases/latest | grep "browser_download_url" | grep "drift_worker.js" | cut -d '"' -f 4)

if [ -n "$SQLITE_URL" ]; then
  wget -O web/sqlite3.wasm "$SQLITE_URL"
else
  echo "sqlite3.wasm URL not found."
fi

if [ -n "$DRIFT_URL" ]; then
  wget -O web/drift_worker.js "$DRIFT_URL"
else
  echo "drift_worker.js URL not found."
fi