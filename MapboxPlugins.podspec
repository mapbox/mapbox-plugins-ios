
Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.name         = "MapboxPlugins"
  s.version      = "0.0.1"
  s.summary      = "Experimental plugins to supercharge your maps."

  # This description is used to generate tags and improve search results.
  s.description  = "Add plugins to your Mapbox basemaps. Each plugin is packaged as a subspec. At the moment, the following plugin is available:
                    * “Traffic” adds traffic congestion layers to a map view.
                    Mapbox Plugins require version 3.6 of the Mapbox iOS SDK or higher."
  s.homepage     = "https://github.com/mapbox/mapbox-plugins-ios/"
  s.screenshot = 'https://github.com/mapbox/mapbox-plugins-ios/blob/master/TrafficPlugin/trafficplugin.gif'
  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.license = { :type => "ISC", :file => "LICENSE.md" }

# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.author = { "Mapbox" => "mobile@mapbox.com" }
s.social_media_url = "https://twitter.com/mapbox"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #

  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source       = { :git => "https://github.com/mapbox/mapbox-plugins-ios.git", :branch => "traffic-plugin" }

  s.module_name = 'MapboxPlugins'

  s.subspec 'PluginKit' do |core|
    core.source_files  = 'PluginKit/*.h'
    core.dependency 'Mapbox-iOS-SDK'
  end

  s.subspec 'Traffic' do |traffic|
    traffic.source_files = 'TrafficPlugin/*.{h,m}'
    traffic.dependency 'MapboxPlugins/PluginKit'
  end

end
