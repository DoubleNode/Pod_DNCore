source 'git@github.com:DoubleNode/SpecsPrivateRepo.git'
source 'git@github.com:DoubleNodeOpen/CocoapodsSpecsRepo.git'
source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

inhibit_all_warnings!

platform :ios, '11.0'

target 'DNCore' do
  # Pods for DNCore
  pod 'AFNetworking', '~> 3.0'
  pod 'ColorUtils'
  pod 'NSLogger'
  pod 'PodAsset'
  pod 'SDVersion'

  target 'DNCoreTests' do
    inherit! :search_paths

    # Pods for testing
    pod 'Gizou', :git => "git@github.com:doublenode/Gizou.git"
    pod 'OCMock'
  end

end
