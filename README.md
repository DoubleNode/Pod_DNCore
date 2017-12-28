Steps to Update Pod
------------------------
0. For New Install Only:
pod repo add Four23Creative https://github.com/Four23Creative/SpecsPrivateRepo.git
pod repo update Four23Creative

1. Check local files
pod lib lint --sources=git@github.com:Four23Creative/SpecsPrivateRepo.git,master --private --allow-warnings

2. Create tag and push to github

3. Check repo file
pod spec lint --sources=git@github.com:Four23Creative/SpecsPrivateRepo.git,master --private --allow-warnings

4. Final Submit
pod repo push Four23Creative DNCore.podspec --allow-warnings


Steps to Reset Podfile Pods
--------------------------------
When changing pod's "path" to/from development mode:

rm Pods/Manifest.lock && rm Podfile.lock && pod install
