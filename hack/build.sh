# Create build dir
mkdir /src/build
cd /src/build

# Activate the venv that has 'appimage-builder' in
source /venv/bin/activate

# Build the AppImage
appimage-builder --recipe ../AppImageBuilder.yml