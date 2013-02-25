//
//  SGShareView.h
//  SGShareKit
//
//  Created by Simon Grätzer on 24.02.13.
//  Copyright (c) 2013 Simon Peter Grätzer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SGShareViewDelegate;
@class SGShareView;
typedef void (^SGShareViewCallback)(SGShareView*);

@interface SGShareView : UIView <UITableViewDataSource, UITableViewDelegate> {
@protected
    NSMutableArray *urls;
    NSMutableArray *images;
}

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<SGShareViewDelegate> delegate;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *initialText;

+ (void)addService:(NSString *)name image:(UIImage *)image handler:(SGShareViewCallback)handler;

+ (SGShareView *)shareView;
- (void)show;
- (void)hide;

- (void)addURL:(NSURL *)url;
- (void)addImage:(UIImage *)image;
@end


@protocol SGShareViewDelegate <NSObject>

- (void)shareView:(SGShareView *)shareView didSelectService:(NSString*)name;
- (void)shareViewDidCancel:(SGShareView *)shareView;

@end