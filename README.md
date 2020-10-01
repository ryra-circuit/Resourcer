# Resourcer
This is communication based library with several types of communication, maps, file/media service, iOS share sheet supports

### Requirements
- iOS 11.0+
- Xcode 10+

### Installation

#### [Cocoapods](https://cocoapods.org/pods/Resourcer)
pod 'Resourcer'

### Add below codes (Required items) into info.plist before using Media picker or/and audio recording services
```xml
<key>NSCameraUsageDescription</key>
<string>Take camera photos for sending media</string>
```
```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Take camera photos for sending media</string>
```
```xml
<key>NSPhotoLibraryAddUsageDescription</key>
<string>Please allow access to save media in your photo library</string>
```
```xml
<key>NSMicrophoneUsageDescription</key>
<string>Please allow access to record audio for media sending</string>
```

### Add below codes (Required items) into info.plist before using Location services
```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>App needs to detect your location for sending location</string>
```
```xml
<key>NSLocationAlwaysUsageDescription</key>
<string>App needs to detect your location for sending location</string>
```
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>App needs to detect your location for sending location</string>
```
```xml
<key>NSLocationUsageDescription</key>
<string>App needs to detect your location for sending location</string>
```

### Add below code into info.plist before using Google Maps directions
```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>comgooglemaps</string>
    <string>comgooglemaps-x-callback</string>
</array>
```

### Add below code into info.plist before using Documents services
```xml
<key>UIFileSharingEnabled</key>
    <true/>
```
```xml
<key>LSSupportsOpeningDocumentsInPlace</key>
    <true/>
```
