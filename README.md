# SGShareKit

iOS sharing view. Supporting for iOS 6 Social.framework, Twitter.framework, MessageUI.framework

### Example Usage

SGShareView works like an UIAlertView. For each instance, a new UIWindow is created on top of the main window
SGShareView does not interfere with your view hierarchy. Just make sure the rootViewController is properly set.

	#import "SGShareView.h"
	#import "SGShareView+UIKit.h"
	
	// ...
	SGShareView *share = [SGShareView shareView];
	share.initialText = @"Hello World!";
	[share addURL:[NSURL URLWithString:@"http://google.com"]];
	//share.delegate = self;
	[share show];
	

![Logo](https://raw.github.com/graetzer/SGShareKit/master/Demo/screenshot.png)

### License

	Copyright [yyyy] [name of copyright owner]
	
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at
	
		http://www.apache.org/licenses/LICENSE-2.0
		
	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
	