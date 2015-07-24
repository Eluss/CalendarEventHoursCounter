all: clean gyp pods open

list:
	xcodebuild -workspace 'app.xcworkspace' -list

build:
	xcodebuild -workspace 'app.xcworkspace' -scheme all

gyp:
	gyp Events.gyp --depth=. -f xcode -DOS=ios
	ruby scripts/fix-project.rb Events.xcodeproj

pods:
	pod install
	ruby scripts/cocoapods_post_install.rb

open:
	#open app.xcworkspace

clean:
	rm -rf ~/Library/Developer/Xcode/DerivedData/
	rm -rf Podfile.lock
	rm -rf Pods
	rm -rf *.xc*
	rm -rf Gemfile.lock
