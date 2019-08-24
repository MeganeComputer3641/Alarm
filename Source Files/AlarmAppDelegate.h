//
//  AlarmAppDelegate.h
//  Alarm
//
//  Created by Megane.computer on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//
//

#import <MediaPlayer/MediaPlayer.h>
#import "AlarmViewController.h"

@class AlarmViewController;

@interface AlarmAppDelegate : UIResponder <UIApplicationDelegate>
{
    MPMoviePlayerViewController *mpmPlayerViewController; //スプラッシュムービー用メンバ変数
    UIViewController *rootviewController; //ルートビューコントローラ用メンバ変数
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AlarmViewController *viewController;



@end
