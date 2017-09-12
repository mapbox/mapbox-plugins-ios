#
#  Be sure to run `pod spec lint MapboxPlugins.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "MapboxPlugins"
  s.version      = "0.0.1"
  s.summary      = "Experimental plugins to supercharge your maps."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = "Add plugins to your Mapbox basemaps. Mapbox Plugins allow you to add a traffic layer to your maps."

  s.homepage     = "https://github.com/mapbox/mapbox-plugins-ios/"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.license = { :type => "ISC", :file => "LICENSE.md" }

# ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

s.author = { "Mapbox" => "mobile@mapbox.com" }
s.social_media_url = "https://twitter.com/mapbox"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  s.platform     = :ios, "10.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/mapbox/mapbox-plugins-ios.git", :branch => "traffic-plugin" }

  s.module_name = 'MapboxPlugins'

  s.subspec 'PluginKit' do |core|
    core.source_files  = 'PluginKit/*.h'
    core.dependency 'Mapbox-iOS-SDK', "~> 3.6"
  end

  s.subspec 'Traffic' do |traffic|
    traffic.source_files = 'TrafficPlugin/*.{h,m}'
    traffic.dependency 'MapboxPlugins/PluginKit'
  end

end
