
#import <UIKit/UIKit.h>
#import "NADView.h"
#import <MediaPlayer/MediaPlayer.h>


@class AlarmViewController;

@interface AlarmAppDelegate : UIResponder <UIApplicationDelegate>
{
    MPMoviePlayerViewController *mpmPlayerViewController; //スプラッシュムービー用メンバ変数
    UIViewController *rootviewController; //ルートビューコントローラ用メンバ変数
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AlarmViewController *viewController;
@property (nonatomic, retain) NADView *nadView;
//@property (copy) void (^backgroundSessionCompletionHandler)();



@end
