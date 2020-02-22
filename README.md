# Resourcer
This is communication based library with several types of communication, maps, file/media service, iOS share sheet supports

### Requirements
- iOS 11.0+
- Xcode 10+

### Installation

#### [Cocoapods](https://cocoapods.org/pods/Resourcer)
pod 'Resourcer'

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
