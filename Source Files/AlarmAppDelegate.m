//
//  AlarmAppDelegate.m
//  Alarm
//
//  Created by Megane.computer on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//


#import "AlarmAppDelegate.h"
#import <NCMB/NCMB.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>


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
    
    DLog(@"\n\n[versionNo]:%@\n[buildNo]:%@\n[OS VERSION]: %@\n\n", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],[UIDevice currentDevice].systemVersion);
    
    // iphone4,5両対応
    UIStoryboard *storyBoard;
    NSString *storyBoardName;
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
    storyBoard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    
    // 選択されたStoryBoardを初期viewControllerへ登録
    rootviewController = [storyBoard instantiateInitialViewController];
    
    // ルートウィンドウへ
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //スプラッシュムービー再生判断
    [self splash:launchOptions];
    
    self.viewController = [[AlarmViewController alloc] initWithNibName:@"AlarmViewController" bundle:nil];
    
    
    
#pragma mark -【Baas】リモート通知関連
    
#if DEBUG
    NSString *NCMBappKey = @"";
    NSString *NCMBcliKey = @"";
#else
    NSString *NCMBappKey = @"";
    NSString *NCMBcliKey = @"";
#endif
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        //iOS7以上なら、NCMB関連処理を実行
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        DLog(@"\n\n[DT USEFLAG]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"]);
        
        #pragma mark -【Baas】AppKey、ClientKeyの登録
        [NCMB setApplicationKey:NCMBappKey clientKey:NCMBcliKey];
        
        if ([userdefaults boolForKey:@"DT Useflag"])
        {
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
                /* iOS8以上でのdvtokenID取得 */
                DLog(@"\n\n[OS VERSION]: iOS 8以上\n\n");
                UIUserNotificationType type = UIUserNotificationTypeAlert |
                                              UIUserNotificationTypeBadge |
                                              UIUserNotificationTypeSound;
                UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type
                                                                                        categories:nil];
                [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            }else{
                /* iOS7でのdvtokenID取得 */
                DLog(@"\n\n[OS VERSION]: iOS 7以下\n\n");
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
                 (UIRemoteNotificationTypeAlert |
                  UIRemoteNotificationTypeBadge |
                  UIRemoteNotificationTypeSound)];
            }
        }
    }

#pragma mark -【GA】初期化
    GA_INIT_TRACKER(60, @""); //解析データの送信間隔：60秒
    
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



#pragma mark -【Baas】配信端末情報登録
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog();
    NSString *device_id = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // dvTokenID更新判断
    if (![[userdefaults stringForKey:@"dvTokenID"] isEqualToString:device_id])
    {
        // アプリに保存されているIDと取得したIDが違う場合は、dvTokenIDを更新
        [userdefaults setObject:device_id forKey:@"dvTokenID"];
        [userdefaults synchronize];
        NCMBInstallation *currentInstallation = [NCMBInstallation currentInstallation];
        [currentInstallation setDeviceTokenFromData:deviceToken];
        [currentInstallation setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
        [currentInstallation setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
        [currentInstallation saveInBackgroundWithBlock:^(NSError *error)
         {
             if(!error){
                 //端末情報の登録が成功した場合の処理
                 DLog(@"\n\n[DEVICETOKEN ID]:SAVE\n[ID]:%@\n[NCMB SAVE]:SUCCESS\n[CURRENT INSTALLATION]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], [NCMBInstallation currentInstallation]);
             } else {
                 //端末情報の登録が失敗した場合の処理
                 DLog(@"\n\n[ERROR CODE]:%ld\n[ERROR]:%@\n\n", (long)error.code, error);
                 if (error.code == 409001){
                     //失敗理由が重複だった場合は、登録済みの端末情報を取得し、BaaS側を更新する
                     [self updateExistInstallation:currentInstallation];
                 } else {
                     //重複以外の理由での失敗の場合は、アプリ内のdvTokenIDを初期化
                     [userdefaults setObject:@"" forKey:@"dvTokenID"];
                     [userdefaults synchronize];
                     DLog(@"\n\n[DEVICETOKEN ID]:INITIALIZE\n[ID]:%@\n[NCMB SAVE]:SAVE MISS\n[CURRENT INSTALLATION]:%@\n[ERROR]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], [NCMBInstallation currentInstallation], error);
                 }
             }
         }];
    }
    else
    {
        DLog(@"\n\n[DEVICETOKEN ID]:NOT SAVE(SAME)\n\n");
    }
    
}


#pragma mark -【Baas】配信端末情報上書き処理
-(void)updateExistInstallation:(NCMBInstallation*)currentInstallation
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NCMBQuery *installationQuery = [NCMBInstallation query];
    [installationQuery whereKey:@"deviceToken" equalTo:currentInstallation.deviceToken];
    
    NSError *searchErr = nil;
    NCMBInstallation *searchDevice = [installationQuery getFirstObject:&searchErr];
    
    if (!searchErr){
        
        DLog(@"\n\n[QUERY APPVERSION]:%@\n[CURRENT APPVERSION]:%@\n\n",[searchDevice objectForKey:@"appVersion"], [currentInstallation objectForKey:@"appVersion"]);
        
        if ([searchDevice objectForKey:@"appVersion"] == nil || ![[searchDevice objectForKey:@"appVersion"] isEqualToString:[currentInstallation objectForKey:@"appVersion"]]){
            //アプリ側とBaaS側でappVersionが違う場合は、端末情報を上書き保存する
            currentInstallation.objectId = searchDevice.objectId;
            [currentInstallation setObject:[[UIDevice currentDevice] systemVersion] forKey:@"osVersion"];
            [currentInstallation setObject:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"appVersion"];
            [currentInstallation saveInBackgroundWithBlock:^(NSError *error)
             {
                if (!error){
                    //端末情報更新に成功したときの処理
                    DLog(@"\n\n[DEVICETOKEN ID]:SAVE(DUPLICATE)\n[ID]:%@\n[NCMB SAVE]:OVERRIDE SUCCESS\n[CURRENT INSTALLATION]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], [NCMBInstallation currentInstallation]);
                } else {
                    //端末情報更新に失敗したときの処理
                    DLog(@"\n\n[DEVICETOKEN ID]:SAVE(DUPLICATE)\n[ID]:%@\n[NCMB SAVE]:OVERRIDE MISS\n[CURRENT INSTALLATION]:%@\n[ERROR]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], [NCMBInstallation currentInstallation], error);
                }
             }];
        } else {
            //アプリ側とBaaS側でappVersionが同一なら上書きせず終了
            DLog(@"\n\n[DEVICETOKEN ID]:SAVE(DUPLICATE)\n[ID]:%@\n[NCMB SAVE]:NOT OVERRIDE\n[Baas appVersion]:%@\n[App appVersion]:%@\n[CURRENT INSTALLATION]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], [searchDevice objectForKey:@"appVersion"], [currentInstallation objectForKey:@"appVersion"], [NCMBInstallation currentInstallation]);
        }
        
    } else {
        //登録済みの端末情報の取得に失敗したときの処理
        DLog(@"\n\n[DEVICETOKEN ID]:SAVE(DUPLICATE)\n[ID]:%@\n[NCMB SAVE]:QUERY MISS\n[ERROR DETAL]:%@\n[CURRENT INSTALLATION]:%@\n\n", [userdefaults stringForKey:@"dvTokenID"], searchErr, [NCMBInstallation currentInstallation]);
    }
}


#pragma mark -【Baas】配信端末情報登録エラー時
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"Error : %@ ",[error localizedDescription]);
}


#pragma mark -【Baas】バックグラウンド時Push通知受領時の処理
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
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateFormatter *df = [[NSDateFormatter alloc]init];
//            [df setLocale:[NSLocale systemLocale]];
//            [df setTimeZone:[NSTimeZone systemTimeZone]];
//            [df setCalendar:calendar];
//            [df setDateFormat:@"HH:mm"];
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
                                            #if DEBUG
                                            
                                            NSError *jsonError;
                                            // JSONをパース
                                            
                                            NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                                            
                                            #endif
                                            
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
                                                
                                                handler(UIBackgroundFetchResultNewData);
                                                
                                            }
                                            else if(applicationState == UIApplicationStateBackground)
                                            {
                                                
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
                                                
                                                handler(UIBackgroundFetchResultNewData);
                                                
                                                // バックグラウンドのときはローカル通知で告知
                                                [self DTNotification];
                                            }
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
                                            
                                            handler(UIBackgroundFetchResultNewData);                                        }
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
            DLog(@"\n\n[DERAOKITW ENABLE]:ON\n[PUSH ID]:NOT MATCH\n[UE PUSH ID]:%@\n[NOTIF PUSH ID]:%@\n\n",[userDefaults stringForKey:@"Push ID"] ,userInfo[@"pushID"]);
        }
    }
    else
    {
        handler(UIBackgroundFetchResultNoData);
        DLog(@"\n\n[DERAOKITW ENABLE]:OFF\n\n");
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    DLog();
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog();
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


/*
 #pragma mark -【DT】バックグラウンド時のPUSH通知登録タスク実行開始delegateメソッド
 - (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
 {
 DLog(@"Save completionHandler");
 self.backgroundSessionCompletionHandler = completionHandler;
 }
 */


@end
