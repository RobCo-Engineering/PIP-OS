# Builds the current repo state as an ARM64 AppImage for running on the Raspberry Pi
export APP_VERSION=$(git describe --tags --dirty)
docker run --platform linux/arm64 -it -v ${PWD}:/src -e APP_VERSION --name qt-build --rm carlonluca/qt-dev:6.9.0 /src/hack/build.sh
