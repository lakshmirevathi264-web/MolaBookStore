# MolaBookStore
Project for Students

## Build & Run (dev container)

1. Compile Java sources (uses installed JDK).

```bash
cd MolaBookStore
mkdir -p target/classes
find src/main/java -name '*.java' > /tmp/sources.txt
javac -d target/classes -cp 'WebContent/WEB-INF/lib/*' @/tmp/sources.txt
```

2. Deploy to local Tomcat (this workspace includes a `tomcat/` directory used during development).

```bash
# copy classes and JSPs into the exploded webapp
cp -r target/classes/* tomcat/webapps/MolaBookStore/WEB-INF/classes/
cp WebContent/*.jsp tomcat/webapps/MolaBookStore/
cp -r WebContent/WEB-INF tomcat/webapps/MolaBookStore/
# restart Tomcat
tomcat/bin/shutdown.sh || true
tomcat/bin/startup.sh
```

3. Quick tests (examples)

```bash
# Signup
curl -i -X POST 'http://localhost:8080/MolaBookStore/signup' -d 'username=testuser&password=password1'
# Login and save cookies
curl -i -c /tmp/cookies.txt -X POST 'http://localhost:8080/MolaBookStore/login' -d 'username=testuser&password=password1'
# Add to cart (AJAX)
curl -i -b /tmp/cookies.txt -H 'X-Requested-With: XMLHttpRequest' -X POST 'http://localhost:8080/MolaBookStore/addToCart' -d 'bookId=1'
```

If you want, I can add a small test script to automate the smoke tests and commit the changes.
