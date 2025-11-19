#!/usr/bin/env bash
set -euo pipefail
# Usage: ./build_and_deploy.sh [tomcat-path]
WORKDIR=$(cd "$(dirname "$0")" && pwd)
TOMCAT_DIR=${1:-$WORKDIR/tomcat}

echo "Working dir: $WORKDIR"
echo "Tomcat dir: $TOMCAT_DIR"

echo "1) Run password migrator"
java -cp "$WORKDIR/target/classes:$WORKDIR/WebContent/WEB-INF/lib/*" com.bookstore.tools.PasswordMigrator || true

echo "2) Compile Java sources"
mkdir -p "$WORKDIR/target/classes"
find "$WORKDIR/src/main/java" -name '*.java' > /tmp/molabook_sources.txt
javac -d "$WORKDIR/target/classes" -cp "$WORKDIR/WebContent/WEB-INF/lib/*" @/tmp/molabook_sources.txt

echo "3) Package WAR (MolaBookStore.war)"
cd "$WORKDIR"
rm -f MolaBookStore.war
jar -cvf MolaBookStore.war -C WebContent . -C target/classes . > /dev/null
echo "WAR created: $WORKDIR/MolaBookStore.war"

if [ -d "$TOMCAT_DIR" ]; then
  echo "4) Deploy to Tomcat webapps (exploded)"
  WEBAPP="$TOMCAT_DIR/webapps/MolaBookStore"
  mkdir -p "$WEBAPP/WEB-INF/classes"
  # copy classes
  rm -rf "$WEBAPP/WEB-INF/classes" || true
  mkdir -p "$WEBAPP/WEB-INF/classes"
  cp -r "$WORKDIR/target/classes/"* "$WEBAPP/WEB-INF/classes/"
  # copy JSPs and web content
  cp -r "$WORKDIR/WebContent/"* "$WEBAPP/"
  # ensure libs are present
  mkdir -p "$WEBAPP/WEB-INF/lib"
  cp -v "$WORKDIR/WebContent/WEB-INF/lib/"*.jar "$WEBAPP/WEB-INF/lib/" || true
  # touch web.xml to trigger reload
  if [ -f "$WEBAPP/WEB-INF/web.xml" ]; then
    touch "$WEBAPP/WEB-INF/web.xml"
  fi
  # restart tomcat to ensure new classes/jars loaded
  if [ -x "$TOMCAT_DIR/bin/shutdown.sh" ]; then
    echo "Restarting Tomcat at $TOMCAT_DIR"
    "$TOMCAT_DIR/bin/shutdown.sh" || true
    sleep 1
    "$TOMCAT_DIR/bin/startup.sh"
    echo "Tomcat restarted."
  else
    echo "Tomcat scripts not found or not executable; deployed files copied to $WEBAPP"
  fi
else
  echo "Tomcat not found at $TOMCAT_DIR; WAR built but not deployed. Copy it to your container or Tomcat webapps dir to deploy."
fi

echo "Done."
