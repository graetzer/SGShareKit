//
//  SGShareView.m
//  SGShareKit
//
//  Created by Simon Grätzer on 24.02.13.
//
//
//  Copyright 2013 Simon Peter Grätzer
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "SGShareView.h"

#if !__has_feature(objc_arc)
#error SGShareView must be built with ARC.
// You can partially turn on ARC by adding -fobjc-arc to the build phase for each file.
#endif

#define POPLISTVIEW_HEADER_HEIGHT 50.
#define RADIUS 5.

@interface SGShareViewController : UIViewController
@end

static NSMutableArray *Services;
static NSMutableArray *LaunchURLHandler;

@interface SGShareView ()
@property(strong, nonatomic) UIWindow *myWindow;
@end

CGFloat UIInterfaceOrientationAngleOfOrientation(UIInterfaceOrientation orientation);

@implementation SGShareView {
    NSArray *_options;
    CGRect _bgRect;
    UIColor *_bgColor;
}

+ (void)addService:(NSString *)name image:(UIImage *)image handler:(SGShareViewCallback)handler {
    if (!Services)
        Services = [[NSMutableArray alloc] initWithCapacity:5];
    
    if (name && image)
        [Services addObject:@{@"img":image, @"text":name, @"handler" : [handler copy]}];
    else
        [Services addObject:@{@"text":name, @"handler" : [handler copy]}];
}

+ (void)addLaunchURLHandler:(SGShareViewLaunchURLHandler)handler {
    if (!LaunchURLHandler)
        LaunchURLHandler = [[NSMutableArray alloc] initWithCapacity:5];
    [LaunchURLHandler addObject:[handler copy]];
}

+ (BOOL)handleURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    for (SGShareViewLaunchURLHandler handler in LaunchURLHandler) 
        if (handler(url, sourceApplication, annotation))
            return YES;
    
    return NO;
}

+ (SGShareView *)shareView {
    return [[SGShareView alloc] initWithFrame:CGRectZero];
}

- (void)show {
    self.myWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.myWindow.windowLevel = UIWindowLevelAlert;
    self.myWindow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.24];
    self.myWindow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
    UIViewController *vC = [SGShareViewController new];
    vC.view = self;
    vC.wantsFullScreenLayout = YES;
    self.myWindow.rootViewController = vC;
    [self.myWindow makeKeyAndVisible];
    [UIViewController attemptRotationToDeviceOrientation];

    if (!_title) {
        if ((self->images != nil) != (self->urls != nil)) {//Xor
            if (self->images)
                _title  = NSLocalizedString(@"Share Picture", @"Share picture title");
            else
                _title  = NSLocalizedString(@"Share Link", @"Share url title");
        } else
            _title = NSLocalizedString(@"Share", @"Share title");
    }
    
    self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1.3, 1.3));
    self.myWindow.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.myWindow.alpha = 1;
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1./1.3, 1/1.3));
    }];
}

- (void)hide {
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1./1.3, 1/1.3));
        self.myWindow.alpha = 0;
    } completion:^(BOOL finished){
        [self removeFromSuperview];
        self.myWindow.hidden = YES;
        self.myWindow = nil;
    }];
}

- (void)addImage:(UIImage *)image {
    if (!self->images)
        images = [NSMutableArray arrayWithCapacity:5];
    
    if (image)
        [images addObject:image];
}

- (void)addURL:(NSURL *)url {
    if (!self->urls)
        urls = [NSMutableArray arrayWithCapacity:5];
    
    if (url)
        [urls addObject:url];
}

#pragma mark - Private

- (id)initWithFrame:(CGRect)frame {
    frame = [UIScreen mainScreen].bounds;
    if (self = [super initWithFrame:frame]) {
        _options = [Services copy];
        _bgColor = [UIColor colorWithWhite:0 alpha:.75];
        
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentMode = UIViewContentModeRedraw;
        
        __strong UITableView *tableView = [[UITableView alloc] initWithFrame:frame];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return self;
}

- (void)layoutSubviews {
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPhone)
        _bgRect = CGRectInset(bounds, bounds.size.width/3.3, bounds.size.height/3.3);
    else
        _bgRect = CGRectInset(bounds, bounds.size.width*0.1, bounds.size.height*0.15);
    
    bounds = self.bounds;
    if (_bgRect.size.height > bounds.size.height)
        _bgRect.size.height = bounds.size.height*0.85;
    
    _bgRect.origin = CGPointMake((bounds.size.width - _bgRect.size.width)/2,
                                 (bounds.size.height - _bgRect.size.height)/2);
    
    CGRect tableRect = CGRectOffset(_bgRect, 0, POPLISTVIEW_HEADER_HEIGHT);
    tableRect.size.height -= POPLISTVIEW_HEADER_HEIGHT - RADIUS;
    self.tableView.frame = tableRect;
}

#pragma mark - Tableview datasource & delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentity = @"Default";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15.];
    }
    
    if ([_options[indexPath.row] respondsToSelector:@selector(objectForKey:)]) {
        cell.imageView.image = _options[indexPath.row][@"img"];
        cell.textLabel.text = _options[indexPath.row][@"text"];
    } else
        cell.textLabel.text = _options[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString* name = _options[indexPath.row][@"text"];
    if ([_delegate respondsToSelector:@selector(shareView:didSelectService:)])
        [_delegate shareView:self didSelectService:name];
    
    //[self hide];
    
    SGShareViewCallback handler = _options[indexPath.row][@"handler"];
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformConcat(self.transform, CGAffineTransformMakeScale(1./1.3, 1/1.3));
        self.myWindow.alpha = 0;
    } completion:^(BOOL finished){
        self.myWindow.hidden = YES;
        if (handler)
            handler(self);
        
        [self removeFromSuperview];
        self.myWindow = nil;
    }];
}

#pragma mark - Detect outside touches
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // tell the delegate the cancellation
    if ([_delegate respondsToSelector:@selector(shareViewDidCancel:)])
        [_delegate shareViewDidCancel:self];
    
    // dismiss self
    [self hide];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    CGRect titleRect = CGRectMake(_bgRect.origin.x + 10, _bgRect.origin.y + 10 + 5,
                                  _bgRect.size.width - 2*10, 30);
    CGRect separatorRect = CGRectMake(_bgRect.origin.x, _bgRect.origin.y + POPLISTVIEW_HEADER_HEIGHT - 2,
                                      _bgRect.size.width, 2);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., _bgColor.CGColor);
    [_bgColor setFill];
    
    float x = _bgRect.origin.x;
    float y = _bgRect.origin.y;
    float width = _bgRect.size.width;
    float height = _bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + RADIUS, y, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + RADIUS, RADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - RADIUS, y + height, RADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - RADIUS, RADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    UIFont *textFont = [UIFont systemFontOfSize:16.];
    [_title drawInRect:titleRect withFont:textFont];
    CGContextFillRect(ctx, separatorRect);
    
    [@"x" drawInRect:titleRect
            withFont:textFont
       lineBreakMode:NSLineBreakByCharWrapping
           alignment:NSTextAlignmentRight];
}

@end

@implementation SGShareViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
