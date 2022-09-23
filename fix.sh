# Delete
rm -rf pubspec.lock
rm -rf ios/Podfile.lock
rm -rf ios/Podfile
rm -rf .flutter-plugins
rm -rf ios/Pods
rm -rf ios/.symlinks
rm -rf ios/Flutter/Flutter.framework
rm -rf ios/Flutter/Flutter.podspec

# Clean
flutter clean
flutter pub get

# IOS
cd ios/
pod deintegrate
pod cache clean --all
#pod repo update
pod install
cd ../

# Build ios
flutter build ios

# Android
cd android/
./gradlew clean
./gradlew build

# Doctor
flutter doctor