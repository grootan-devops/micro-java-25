# micro-java-25

Minimal Eclipse Temurin Java runtime image built directly with Buildah on top
of the Grootan micro-root image. The project intentionally contains no
Dockerfile.

## Image

- Registry: Docker Hub
- Repository: `grootantec/micro-java-25`
- Release: `1.0.0`
- Temurin: `25.0.3+9`
- Base: `grootantec/micro-root:1.5.1`

The image uses `/usr/bin/dumb-init --` as its entrypoint and starts `java` by
default. `JAVA_HOME` is `/usr/local/java/current`; `java` and `keytool` are
available in `/usr/bin`.

## Build and test

The GitHub Actions workflows build the image with Buildah, execute
`ci_image_test.sh` as UID `10001:10001`, and run a blocking Trivy image scan.
The same checks run for pull requests and release candidates.

## License

This project is licensed under the GNU Affero General Public License v3.0.
See [LICENSE.md](LICENSE.md).
