# mapbox-plugins-ios
Experimental plugins to supercharge your maps ⚡️

Plugins allow users to easily add features to their Mapbox maps. Plugins are focused on one feature, and designed to be simple to use.

## Available Plugins

- [Traffic](https://github.com/mapbox/mapbox-plugins-ios/tree/master/TrafficPlugin) - Add a traffic layer to your Mapbox basemap .

## Using Test App

Test out Mapbox Plugins in the TestApp.

1. Run `pod update` to install the Mapbox iOS SDK.

2. Create a text file called `mapbox_access_token` and add your [Mapbox Access token](https://www.mapbox.com/help/how-access-tokens-work/) to it.

## Installing Plugins

There are currently two ways to install Mapbox Plugins:

1. **CocoaPods**

  To install all Mapbox Plugins, add the following to your Podfile:
```
  target 'YourAppName' do
  use_frameworks!
  `pod MapboxPlugins`
end
```

  To only install the Mapbox Traffic Plugin, replace `pod MapboxPlugins` with `pod MapboxPlugins/Traffic`.
  Note that the CocoaPod does include [Mapbox iOS SDK](https://www.mapbox.com/ios-sdk/) v3.6 as a dependency, and should update to the latest patch release of v3.6 when you run `pod update`.

2. If you prefer not to use CocoaPods, copy the files for the plugin that you would like to use into your project. You will need to use a bridging header if your project is written in Swift.

Carthage support is coming soon.

## Additional Support

Plugins are intended to be easy to use. If you see any issues related to Mapbox plugins, please open a ticket with steps to reproduce the issue.

For questions related to the Mapbox iOS SDK, please visit https://www.mapbox.com/help/
