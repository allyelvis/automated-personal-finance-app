#!/bin/bash

# Project Information
PROJECT_NAME="TVStreamingApp"
PACKAGE_NAME="com.example.tvstreaming"

# Check for dependencies
function check_dependencies() {
    echo "Checking for required dependencies..."
    command -v git >/dev/null 2>&1 || { echo >&2 "Git is required. Installing..."; sudo apt update && sudo apt install git -y; }
    command -v java >/dev/null 2>&1 || { echo >&2 "Java is required. Installing..."; sudo apt install openjdk-11-jdk -y; }
    command -v sdkmanager >/dev/null 2>&1 || { echo >&2 "Android SDK Tools are required. Please install Android Studio manually."; exit 1; }
    echo "All dependencies are satisfied."
}

# Create Android project
function create_android_project() {
    echo "Creating Android project: $PROJECT_NAME..."
    if [ -d "$PROJECT_NAME" ]; then
        echo "Project directory already exists. Exiting."
        exit 1
    fi

    mkdir "$PROJECT_NAME"
    cd "$PROJECT_NAME" || exit
    npx react-native init $PROJECT_NAME --package $PACKAGE_NAME
    echo "Android project created successfully."
}

# Install required libraries
function install_dependencies() {
    echo "Installing required libraries..."

    # FFmpeg Kit for Android
    echo "Adding FFmpegKit to build.gradle..."
    cd android/app || exit
    sed -i '/dependencies {/a implementation "com.arthenica:ffmpeg-kit-min:5.1.LTS"' build.gradle
    cd ../..

    # Libstreaming library (manual setup may be required for latest compatibility)
    echo "Adding libstreaming..."
    git clone https://github.com/fyhertz/libstreaming.git libs/libstreaming

    echo "Required libraries installed."
}

# Configure permissions
function configure_permissions() {
    echo "Configuring AndroidManifest.xml permissions..."
    MANIFEST_PATH="android/app/src/main/AndroidManifest.xml"
    sed -i '/<application/a \
        <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> \
        <uses-permission android:name="android.permission.CHANGE_WIFI_STATE" /> \
        <uses-permission android:name="android.permission.INTERNET" /> \
        <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /> \
        <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />' $MANIFEST_PATH
    echo "Permissions configured."
}

# Final instructions
function final_instructions() {
    echo "Project setup is complete!"
    echo "To start development:"
    echo "1. Open the $PROJECT_NAME directory in Android Studio."
    echo "2. Sync the Gradle project."
    echo "3. Build and test your app."
    echo "Happy coding!"
}

# Run script
check_dependencies
create_android_project
install_dependencies
configure_permissions
final_instructions