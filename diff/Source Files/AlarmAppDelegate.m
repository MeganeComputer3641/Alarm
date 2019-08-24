
#import "AlarmAppDelegate.h"
#import "AlarmViewController.h"
#import <NCMB/NCMB.h>

@implementation AlarmAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DLog();
    
    //ローカル通知からの起動時
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        //登録されている全ての通知を削除
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    
    // iphone4,5両対応
    UIStoryboard *storyboard;
    NSString * storyBoardName;
    CGRect r = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    
    // 縦の長さが480の場合、古いiPhoneだと判定
    if(r.size.height == 480)
    {
        storyBoardName = @"MainStoryboard_Old_iPhone";
    }
    else
    {
        storyBoardName =@"MainStoryboard_iPhone";
    }
    
    // StoryBoardのインスタンス化
    storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    // 選択されたStoryBoardを初期viewControllerへ登録
    rootviewController = [storyboard instantiateInitialViewController];
    
    // ルートウィンドウへ
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //スプラッシュムービー再生判断
    [self splash:launchOptions];
    
    self.viewController = [[AlarmViewController alloc] initWithNibName:@"AlarmViewController" bundle:nil];
    
#pragma mark -【nifty Baas】リモート通知関連
    // リモート通知許可状態取得
    //    [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    // dvToken再取得
    //    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    
#if DEBUG
    NSString *NCMBappKey = @"8decc14d72b01d499ab485fde1ef4871c08e20650674ee234c7303a7363552f5";
    NSString *NCMBcliKey = @"9e2f58bd21ecb4752d49204a6154060ca96b96b992ded1ad22553f2e9b0ed7a3";
#else
    NSString *NCMBappKey = @"7ca29ccd40c03e93a358518c861d11d579cf7c8fee29f18f21f7d0efcf95571a";
    NSString *NCMBcliKey = @"5896561d911602a333a8773f447497d6fcc2f334bc0dcf111561900a5df6b0d5";
#endif
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        // リモート通知登録
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        DLog(@"\n\n[DT USEFLAG]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"]);
        
        if ([userdefaults boolForKey:@"DT Useflag"])
        {
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        }
    
#pragma mark -【nifty Baas】AppKey、ClientKeyの登録
        [NCMB setApplicationKey:NCMBappKey
                      clientKey:NCMBcliKey];
    }
#pragma mark -【GA】初期化
    GA_INIT_TRACKER(30, @"UA-47406187-1"); //解析データの送信間隔：30秒
    
#pragma mark -【GA】初回起動
    GA_TRACK_EVENT(@"総起動", @"初回起動", @"", nil);
    
    return YES;
}


#pragma mark -【起動画面】SplashMovie開始判断
-(void)splash:(NSDictionary *)launchOptions
{
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    //ローカル通知以外からの起動時はSplashMovieを再生
    if (!localNotif)
    {
        //スプラッシュムービー停止時のメソッドを明示
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(splashMoviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:nil];
        // Windowスクリーンのサイズを取得
        CGRect r = [[UIScreen mainScreen] bounds];
        
        // iphone4,5判断
        if(r.size.height == 480)
        {
            // 高さが480の時 ⇒ iphone 4
            NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"splash0314_ip4" ofType:@"mp4"]];
            mpmPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:filePath ];
        }
        else
        {
            // それ以外の時 ⇒ iphone 5
            NSURL *filePath = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"splash0314_ip5" ofType:@"mp4"]];
            mpmPlayerViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:filePath ];
        }
        
        // MoviewplayerのスタイルはNoneで登録(再生バー等の表示なし)
        mpmPlayerViewController.moviePlayer.controlStyle = MPMovieControlStyleNone;
//        [self.window addSubview:mpmPlayerViewController.view];
        [self.window setRootViewController:mpmPlayerViewController];
        [self.window makeKeyAndVisible];
    }
    else
    {
        // ローカル通知からの起動時は通常処理
        self.window.rootViewController = rootviewController;
        [self.window makeKeyAndVisible];
    }
}



#pragma mark -【起動画面】SplashMovie再生後の処理
- (void)splashMoviePlayBackDidFinish:(NSNotification *)notification
{
    // 端末動作の通知登録を削除
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // MainStoryBoardのビューを追加
    self.window.rootViewController = rootviewController;
//    [self.window setRootViewController:rootviewController];
    
    // SplashMovieのビューを削除
    [mpmPlayerViewController.view removeFromSuperview];
}



#pragma mark -【nifty Baas】配信端末情報登録
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *device_id = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // dvTokenID更新判断
    if (![[userDefaults stringForKey:@"dvTokenID"] isEqualToString:device_id])
    {
        // 保存されているIDと取得したIDが違う場合は、dvTokenIDを更新
        NCMBInstallation *currentInstallation = [NCMBInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation save];
        [userDefaults setObject:device_id forKey:@"dvTokenID"];
        [userDefaults synchronize];
        DLog(@"\n\n[DEVICETOKEN ID]:SAVE\n[ID]:%@\n\n", [userDefaults stringForKey:@"dvTokenID"]);
    }
    else
    {
        DLog(@"\n\n[DEVICETOKEN ID]:NOT SAVE(SAME)\n\n");
    }
}


#pragma mark -【nifty Baas】配信端末情報登録エラー時
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (![error code] == 3010)
    {
        DLog(@"Error : %@ ",[error localizedDescription]);
    }
}


#pragma mark -【nifty Baas】バックグラウンド時Push通知受領時の処理
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    DLog(@"\n\n[REMOTENOTIF RECEIVED]\n[USERINFO]\n%@", userInfo);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    
    // デラオキツイートON/OFF アラームON/OFF判別
    if ([userDefaults boolForKey:@"DT Enabled"]==YES && [userDefaults boolForKey:@"Alarm Enabled"]==YES)
    {
        // PUSH IDが等しいかどうかを判別
        if ([userInfo[@"pushID"] isEqualToString:[userDefaults stringForKey:@"Push ID"]])
        {
            // アカウントを再取得
            ACAccountStore* store = [[ACAccountStore alloc] init];
            ACAccountType* type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            NSArray* accounts = [store accountsWithAccountType:type];
            
            // ユーザ・デフォルトからアカウントのIndex番号を取得
            int index = (int)[userDefaults integerForKey:@"Account Index"];
            
            // TweetWords設定
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"HH:mm"];
            NSString *twWord = [userDefaults stringForKey:@"TW Words"];
            NSString *hashTagStr = NSLocalizedString(@"hashTagStr", nil);
            NSString *statusStr = [NSString stringWithFormat:@"%@%@\n", twWord, hashTagStr];
            
            // Tweetリクエストを生成
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"];
            NSDictionary *parameters = @{@"status": statusStr}; //ツイート内容
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST // POST
                                                              URL:url
                                                       parameters:parameters];
            [request setAccount:[accounts objectAtIndex:index]];
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    if (responseData)
                                    {
                                        NSUInteger statusCode = urlResponse.statusCode;
                                        if (200 <= statusCode && statusCode < 300)
                                        {
                                            NSError *jsonError;
                                            // JSONをパース
                                            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                                            
                                            // DT実施告知
                                            if (applicationState == UIApplicationStateActive)
                                            {
                                                // アクティブなときはアラートで告知
                                                NSString *DTEndTitle = NSLocalizedString(@"DTEndTitle", nil);
                                                NSString *DTEndStr = NSLocalizedString(@"DTEndStr", nil);
                                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DTEndTitle
                                                                                               message:DTEndStr
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:@"OK", nil];
                                                [alert show];
                                                
                                                #pragma mark -【GA】Tweet成功時
                                                NSString *twwordsStr;
                                                switch ([userDefaults integerForKey:@"TW Words Number"])
                                                {
                                                    case 1:
                                                        twwordsStr = NSLocalizedString(@"TWLabel1", nil);
                                                        break;
                                                    case 2:
                                                        twwordsStr = NSLocalizedString(@"TWLabel2", nil);
                                                        break;
                                                    case 3:
                                                        twwordsStr = NSLocalizedString(@"TWLabel3", nil);
                                                        break;
                                                    case 4:
                                                        twwordsStr = NSLocalizedString(@"TWLabel4", nil);
                                                        break;
                                                    case 5:
                                                        twwordsStr = NSLocalizedString(@"TWLabel5", nil);
                                                        break;
                                                }
                                                GA_TRACK_EVENT(@"デラオキツイート", @"成功数", twwordsStr, nil);
                                                
//                                                // GA用フラグ更新
//                                                [userDefaults setInteger:1 forKey:@"DT Status"];
//                                                [userDefaults synchronize];
                                                
                                                DLog(@"\n\n[APP STATUS]:ACCTIVE\n[DERAOKITW ENABLE]:ON\n[PUSH ID]: SAME\n[REQUEST ACCOUNT]:%@\n[TWEET]:Success\n[RESPONSE DATA]\n%@\n\n",[userDefaults stringForKey:@"TW Username"] ,jsonData);
                                                
                                            }
                                            else if(applicationState == UIApplicationStateBackground)
                                            {
                                                // バックグラウンドのときはローカル通知で告知
                                                [self DTNotification];
                                                DLog(@"\n\n[APP STATUS]:BACKGROUND\n[DERAOKITW ENABLE]:ON\n[PUSH ID]: SAME\n[REQUEST ACCOUNT]:%@\n[TWEET]:Success\n[RESPONSE DATA]\n%@\n\n",[userDefaults stringForKey:@"TW Username"] ,jsonData);
                                                
                                                #pragma mark -【GA】Tweet成功時
                                                NSString *twwordsStr;
                                                switch ([userDefaults integerForKey:@"TW Words Number"])
                                                {
                                                    case 1:
                                                        twwordsStr = NSLocalizedString(@"TWLabel1", nil);
                                                        break;
                                                    case 2:
                                                        twwordsStr = NSLocalizedString(@"TWLabel2", nil);
                                                        break;
                                                    case 3:
                                                        twwordsStr = NSLocalizedString(@"TWLabel3", nil);
                                                        break;
                                                    case 4:
                                                        twwordsStr = NSLocalizedString(@"TWLabel4", nil);
                                                        break;
                                                    case 5:
                                                        twwordsStr = NSLocalizedString(@"TWLabel5", nil);
                                                        break;
                                                }
                                                GA_TRACK_EVENT(@"デラオキツイート", @"成功数", twwordsStr, nil);
                                                
//                                                // GA用フラグ更新
//                                                [userDefaults setInteger:1 forKey:@"DT Status"];
//                                                [userDefaults synchronize];
                                            }
                                            
                                            handler(UIBackgroundFetchResultNewData);
                                        }
                                        else
                                        {
                                            // 認証エラー、レートリミットオーバーなど
                                            DLog(@"\n\n[DERAOKITW ENABLE]:ON\n[PUSH ID]: SAME\n[REQUEST ACCOUNT]:%@\n[TWEET]:Miss\n[JSON ERROR]\n%@\n\n",[userDefaults stringForKey:@"TW Username"] ,[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
                                            
                                            #pragma mark -【GA】Tweet失敗時
                                            NSString *twwordsStr;
                                            switch ([userDefaults integerForKey:@"TW Words Number"])
                                            {
                                                case 1:
                                                    twwordsStr = NSLocalizedString(@"TWLabel1", nil);
                                                    break;
                                                case 2:
                                                    twwordsStr = NSLocalizedString(@"TWLabel2", nil);
                                                    break;
                                                case 3:
                                                    twwordsStr = NSLocalizedString(@"TWLabel3", nil);
                                                    break;
                                                case 4:
                                                    twwordsStr = NSLocalizedString(@"TWLabel4", nil);
                                                    break;
                                                case 5:
                                                    twwordsStr = NSLocalizedString(@"TWLabel5", nil);
                                                    break;
                                            }
                                            GA_TRACK_EVENT(@"デラオキツイート", @"失敗数", twwordsStr, nil);
                                            
//                                            // GA用フラグ更新
//                                            [userDefaults setInteger:2 forKey:@"DT Status"];
//                                            [userDefaults synchronize];
                                        
                                            handler(UIBackgroundFetchResultFailed);
                                        }
                                    }
                                    else
                                    {
                                        // request自体のエラーをLog出力
                                        DLog(@"\n\n[DERAOKITW ENABLE]:ON\n[PUSH ID]: SAME\n[REQUEST ACCOUNT]:%@\n[TWEET]:REQUEST ERROR\n[ERROR]\n%@\n\n",[userDefaults stringForKey:@"TW Username"] ,error);
                                        
                                        #pragma mark -【GA】Tweet失敗時
                                        NSString *twwordsStr;
                                        switch ([userDefaults integerForKey:@"TW Words Number"])
                                        {
                                            case 1:
                                                twwordsStr = NSLocalizedString(@"TWLabel1", nil);
                                                break;
                                            case 2:
                                                twwordsStr = NSLocalizedString(@"TWLabel2", nil);
                                                break;
                                            case 3:
                                                twwordsStr = NSLocalizedString(@"TWLabel3", nil);
                                                break;
                                            case 4:
                                                twwordsStr = NSLocalizedString(@"TWLabel4", nil);
                                                break;
                                            case 5:
                                                twwordsStr = NSLocalizedString(@"TWLabel5", nil);
                                                break;
                                        }
                                        GA_TRACK_EVENT(@"デラオキツイート", @"失敗数", twwordsStr, nil);
                                        
                                        // GA用フラグ更新
                                        [userDefaults setInteger:2 forKey:@"DT Status"];
                                        [userDefaults synchronize];
                                    
                                        handler(UIBackgroundFetchResultFailed);
                                    }
                                });
             }];
        }
        else
        {
            // PUSH IDが違う時はツイートしない
            handler(UIBackgroundFetchResultNoData);
            DLog(@"\n\n[DERAOKITW ENABLE]:ON\n[PUSH ID]:NO MATCHING\n[UE PUSH ID]:%@\n[NOTIF PUSH ID]:%@\n\n",[userDefaults stringForKey:@"Push ID"] ,userInfo[@"pushID"]);
        }
    }
    else
    {
        handler(UIBackgroundFetchResultNoData);
        DLog(@"\n\n[DERAOKITW ENABLE]:OFF\n\n");
    }
}


//#pragma mark -【DT】バックグラウンド時のPUSH通知登録タスク実行開始delegateメソッド
//- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
//{
//    DLog(@"Save completionHandler");
//    self.backgroundSessionCompletionHandler = completionHandler;
//}


- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog();

    // アラーム通知作成
    [self.viewController AlarmNotification];
//    // PUSH通知作成判断
//    if ([self.viewController DTPushMakeCalc])
//    {
//        // BackgroundでのPush通知登録実施
//        [self.viewController PushCreateInBackgroundTask];
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog();
#pragma mark -【GA】回帰起動
    GA_TRACK_EVENT(@"総起動", @"回帰起動", @"", nil);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog();
    [self.nadView resume]; // 広告のロードを再開
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        [self.viewController DTCheck]; // デラオキツイート可能/不可能 判断
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog();
}


#pragma mark -【ローカル通知】アクティブ時通知受信時の処理
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //登録されている通知を全て削除
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}


#pragma mark -【ローカル通知】DT実施ローカル通知告知
- (void)DTNotification
{
    // 通知インスタンスを生成
    UILocalNotification *localNotif = [[UILocalNotification alloc]init];
    NSDate *today = [NSDate date];
    
    NSString *DTEndStr = NSLocalizedString(@"DTEndStr", nil);
    
    // アラーム通知作成
    localNotif.fireDate = today; // 即通知
    localNotif.timeZone = [NSTimeZone localTimeZone]; // タイムゾーンiphoneで設定されているものに
    localNotif.alertBody = DTEndStr;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    // 通知の登録
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    DLog(@"\n\n[DT NOTIF]:SEND\n\n");
}



@end
