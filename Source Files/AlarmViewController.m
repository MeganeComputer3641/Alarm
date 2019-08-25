//
//  AlarmViewController.m
//  Alarm
//
//  Created by Shuji Takahashi on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//
//

#import "AlarmViewController.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import <NCMB/NCMB.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>



@implementation AlarmViewController


// クラスの初期化
+ (void)initialize
{
#pragma mark -ユーザデフォルトの初期設定
    
    // 初期値の辞書を作成
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    NSString *TWwords1 = NSLocalizedString(@"TWwords1", nil);
    NSString *Sound = @"BELL";
    
    // 初期値を設定
    [defaultValues setValue: @(NO) forKey:@"Alarm Enabled"];
    [defaultValues setValue: @(YES) forKey:@"Wake Up"];
    [defaultValues setValue: @(NO) forKey:@"Notif"];
    [defaultValues setValue: @(NO) forKey:@"AC Enabled"];
    [defaultValues setValue: @(NO) forKey:@"DT Enabled"];
    [defaultValues setValue: @(NO) forKey:@"DT Useflag"];
    [defaultValues setValue: @(NO) forKey:@"Notif Useflag"];
    [defaultValues setValue: @(NO) forKey:@"Adview load"];
    [defaultValues setValue: @(NO) forKey:@"Sound Test"];
    [defaultValues setValue: @(NO) forKey:@"AD VIEW HOME-middle"];
    [defaultValues setValue: @(NO) forKey:@"AD VIEW HOME-under"];
    [defaultValues setValue: @(NO) forKey:@"AD VIEW SETTINGS"];
    [defaultValues setValue: @(NO) forKey:@"AD MIDDLE LOAD"];
    [defaultValues setValue: @(NO) forKey:@"AD UNDER LOAD"];
    [defaultValues setValue: @(NO) forKey:@"Tutorial View"];
    [defaultValues setValue: @0 forKey:@"Alarm Hour"];
    [defaultValues setValue: @0 forKey:@"Alarm Min"];
    [defaultValues setValue: @1 forKey:@"TW Words Number"];
    [defaultValues setValue: @1 forKey:@"Sound Number"];
    [defaultValues setValue: @0 forKey:@"DT Status"];
    [defaultValues setValue: @"" forKey:@"dvTokenID"];
    [defaultValues setValue: @"" forKey:@"TW Username"];
    [defaultValues setValue: @"" forKey:@"Push ID"];
    [defaultValues setValue:TWwords1 forKey:@"TW Words"];
    [defaultValues setValue:Sound forKey:@"Sound Name"];
    [defaultValues setValue: nil forKey:@"Account Index"];
    
    // ユーザ・デフォルトに初期値を登録
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults registerDefaults:defaultValues];
    
    //    DLog(@"defaultValues %@",defaultValues);
}

// アプリ起動後最初の処理
- (void)viewDidLoad
{
    DLog();
    [super viewDidLoad];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
#pragma mark -【View】Tutorial画面
    // Tutorial画面
    DLog(@"\n\n[TUTORIAL VIEW]:%d\n\n", [userDefaults boolForKey:@"Tutorial View"]);

    if (![userDefaults boolForKey:@"Tutorial View"])
    {
        // 初期起動時のみTutorial画面を表示
        _tutorialView.alpha = 1;
        CGRect tutorialViewframe = _tutorialView.frame;
        tutorialViewframe.origin.x = 0.0;
        _tutorialView.frame = tutorialViewframe;
    }
    
    
    // 日時取得タイマー起動
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(driveClock:) userInfo:nil repeats:YES];
    
    // Date Pickerの初期設定
    self.DatePicker.timeZone = [NSTimeZone systemTimeZone];
    self.DatePicker.backgroundColor = [UIColor whiteColor];
    
    // 自動ロックの禁止
    UIApplication *application = [UIApplication sharedApplication];
    application.idleTimerDisabled = YES;
    
    
#pragma mark -【ad】initialize
    // 広告のサイズ
    CGRect iPhone_3_5inch_banner1 = CGRectMake(10, 68, 320, 250); //3.5inch中央広告枠サイズ
    CGRect iPhone_3_5inch_close = CGRectMake(89, 324, 143, 28); //3.5inch中央Closeボタンサイズ
    CGRect iPhone_4inch_banner1 = CGRectMake(10, 129, 320, 250); //4inch中央広告枠サイズ
    CGRect iPhone_4inch_close = CGRectMake(89, 387, 143, 38); //4inch中央Closeボタンサイズ
    CGFloat y = self.view.frame.size.height - 50.0;
    CGRect iPhone_3_5inch_banner2 = CGRectMake(0, y, 320, 50); //3.5inch下部広告枠サイズ
    CGRect iPhone_4inch_banner2 = CGRectMake(0, y, 320, 50); //4inch下部広告枠サイズ
    
    DLog(@"\n\nself.view.frame.size.height: %f\nself.view.frame.origin.y: %f\nCGFloat y: %f\n\n", self.view.frame.size.height, self.view.frame.origin.y, y);
    
    // 3.5inch,4inch両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        self.nadView1 = [[NADView alloc] initWithFrame:iPhone_3_5inch_banner1]; // 中央広告枠の生成
        self.nadView2 = [[NADView alloc] initWithFrame:iPhone_3_5inch_banner2]; // 下部広告枠の生成
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom]; // Closeボタンの生成
        closeButton.frame = iPhone_3_5inch_close; // Closeボタンのサイズ
        buttonTitle = [[UILabel alloc]initWithFrame:iPhone_3_5inch_close]; // Closeボタンタイトルの生成、サイズ
        
        if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
        {
            // ios7以上なら中央広告表示位置を調整
            CGRect nadviewframe = self.nadView1.frame;
            CGRect closebuttonframe = closeButton.frame;
            CGRect buttonTitleframe = buttonTitle.frame;
            nadviewframe.origin.y = self.nadView1.frame.origin.y + 20.0;
            closebuttonframe.origin.y = closeButton.frame.origin.y + 20.0;
            buttonTitleframe.origin.y = buttonTitle.frame.origin.y + 20.0;
            self.nadView1.frame = nadviewframe;
            closeButton.frame = closebuttonframe;
            buttonTitle.frame = buttonTitleframe;
            
            DLog(@"\n\n[OS VERSION]: %f\n[nadView1]: (%f, %f, %f, %f)\n[nadView2]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView1.frame.origin.x, self.nadView1.frame.origin.y, self.nadView1.frame.size.width, self.nadView1.frame.size.height, self.nadView2.frame.origin.x, self.nadView2.frame.origin.y, self.nadView2.frame.size.width, self.nadView2.frame.size.height);
        }
        
        DLog(@"\n\n[OS VERSION]: %f\n[nadView1]: (%f, %f, %f, %f)\n[nadView2]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView1.frame.origin.x, self.nadView1.frame.origin.y, self.nadView1.frame.size.width, self.nadView1.frame.size.height, self.nadView2.frame.origin.x, self.nadView2.frame.origin.y, self.nadView2.frame.size.width, self.nadView2.frame.size.height);
    }
    else // それ以外の場合、4inch
    {
        self.nadView1 = [[NADView alloc] initWithFrame:iPhone_4inch_banner1]; // 中央広告枠の生成
        self.nadView2 = [[NADView alloc] initWithFrame:iPhone_4inch_banner2]; // 下部広告枠の生成
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom]; // Closeボタンの生成
        closeButton.frame = iPhone_4inch_close; // Closeボタンのサイズ
        buttonTitle = [[UILabel alloc]initWithFrame:iPhone_4inch_close]; // Closeボタンタイトルの生成、サイズ
        
        if(([[UIDevice currentDevice].systemVersion floatValue] < 7.0))
        {
            // ios6以下なら中央広告の表示位置を調整
            CGRect nadviewframe1 = self.nadView1.frame;
            CGRect closebuttonframe = closeButton.frame;
            CGRect buttonTitleframe = buttonTitle.frame;
            nadviewframe1.origin.y = self.nadView1.frame.origin.y - 20.0;
            closebuttonframe.origin.y = closeButton.frame.origin.y - 20.0;
            buttonTitleframe.origin.y = buttonTitle.frame.origin.y - 20.0;
            self.nadView1.frame = nadviewframe1;
            closeButton.frame = closebuttonframe;
            buttonTitle.frame = buttonTitleframe;
            
            DLog(@"\n\n[OS VERSION]: %f\n[nadView1]: (%f, %f, %f, %f)\n[nadView2]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView1.frame.origin.x, self.nadView1.frame.origin.y, self.nadView1.frame.size.width, self.nadView1.frame.size.height, self.nadView2.frame.origin.x, self.nadView2.frame.origin.y, self.nadView2.frame.size.width, self.nadView2.frame.size.height);
        }
        
        DLog(@"\n\n[OS VERSION]: %f\n[nadView1]: (%f, %f, %f, %f)\n[nadView2]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView1.frame.origin.x, self.nadView1.frame.origin.y, self.nadView1.frame.size.width, self.nadView1.frame.size.height, self.nadView2.frame.origin.x, self.nadView2.frame.origin.y, self.nadView2.frame.size.width, self.nadView2.frame.size.height);
        
    }
    // 広告削除ボタンの設定
    closeButton.backgroundColor = [UIColor clearColor];
    [closeButton addTarget:self action:@selector(buttonBannerClose:) forControlEvents:UIControlEventTouchUpInside];
    
    // ボタンのタイトル(ラベル)の設定
    buttonTitle.text = @"Close";
    buttonTitle.font = [UIFont fontWithName:@"Copperplate" size:27];
    buttonTitle.textAlignment = NSTextAlignmentCenter;
    buttonTitle.textColor = [UIColor blackColor];
    buttonTitle.backgroundColor = [UIColor clearColor];
    
    /* 検証用apiKeyとspotId
     サイズ      apiKey                                     spotID
     320 x 50
     320 x100
     300 x100
     300 x250
     728 x 90
     アイコン
     */

#if DEBUG
    [self.nadView1 setIsOutputLog:YES]; // 中央広告Log出力ON
    [self.nadView2 setIsOutputLog:YES]; // 下部広告Log出力ON
#else
    [self.nadView1 setIsOutputLog:NO]; // 中央広告Log出力OFF
    [self.nadView2 setIsOutputLog:NO]; // 下部広告Log出力OFF
#endif
    
    // apiKey, spotId.の設定
    [self.nadView1 setNendID:@"" spotID:@""]; //中央広告
    [self.nadView2 setNendID:@"" spotID:@""]; //下部広告
    
    //デリゲートはself
    [self.nadView1 setDelegate:self]; //中央広告
    [self.nadView2 setDelegate:self]; //下部広告
    
    
    //広告のロードを開始  保留:[self.nadView load:[NSDictionary dictionaryWithObjectsAndKeys:@"30",@"retry",nil]];
    [self.nadView1 load]; //中央広告
    [self.nadView2 load]; //下部広告
    
    
    // AlarmViewControllerでの各種通知受け取り設定
    [self addNotificationObserver];
    
    
#pragma mark -【GA】ディスパッチ
    // 並列なキュー(global_queue)で非同期(async)、優先度中(DISPATCH_QUEUE_PRIORITY_DEFAULT)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,
                   ^{
                       [[GAI sharedInstance] dispatch];
                   });
    
#pragma mark -デバッグビルド時の設定
#if DEBUG
    UIButton *debugButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *pushnotifButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *tutorialButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [debugButton setTitle:@"Stop" forState:UIControlStateNormal];
    [tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [pushnotifButton setTitle:@"PushN" forState:UIControlStateNormal];
    [tutorialButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    
    debugButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    tweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    pushnotifButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    tutorialButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    debugButton.tintColor = [UIColor blackColor];
    tweetButton.tintColor = [UIColor blackColor];
    pushnotifButton.tintColor = [UIColor blackColor];
    tutorialButton.tintColor = [UIColor blackColor];
    
    if(window.size.height == 480)
    {
        debugButton.frame = CGRectMake(20, 110, 70, 44);
        tweetButton.frame = CGRectMake(125, 110, 70, 44);
        pushnotifButton.frame = CGRectMake(230, 110, 70, 44);
        tutorialButton.frame = CGRectMake(230, 60, 70, 44);
    }
    else
    {
        debugButton.frame = CGRectMake(20, 344, 70, 44);
        tweetButton.frame = CGRectMake(125, 344, 70, 44);
        pushnotifButton.frame = CGRectMake(230, 344, 70, 44);
        tutorialButton.frame = CGRectMake(237, 60, 70, 44);
    }
    
    [debugButton addTarget:self action:@selector(Alarmstop:) forControlEvents:UIControlEventTouchUpInside];
    [tweetButton addTarget:self action:@selector(TweetTest:) forControlEvents:UIControlEventTouchUpInside];
    [pushnotifButton addTarget:self action:@selector(PushNotifTest) forControlEvents:UIControlEventTouchUpInside];
    [tutorialButton addTarget:self action:@selector(Tutorial) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:debugButton];
    [self.view addSubview:tweetButton];
    [self.view addSubview:pushnotifButton];
    [self.view addSubview:tutorialButton];
#endif
    
}



#pragma mark -ViewControllerでの通知受け取り設定
- (void)addNotificationObserver
{
    DLog();
    
    // 念のため先に削除する
    [self removeNotificationObserver];
    
    // AppDelegateのDidBecomeActive時の通知を設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    // AppDelegateのDidEnterBackground時の通知を設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    // AppDelegateのWillEnterForeground時の通知を設定
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}


#pragma mark -ViewControllerでの通知受け取り設定を解除
- (void)removeNotificationObserver
{
    DLog();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark 【Delegate】DidBecomeActive時の処理
- (void)applicationDidBecomeActive
{
    DLog();
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        [self dtCheck]; // デラオキツイート可能/不可能 判断
    }
}



#pragma mark 【Delegate】DidEnterBackground時の処理
- (void)applicationDidEnterBackground
{
    DLog();
    
    // 広告定期ロード判断
    [self adViewPause];
    
    // アラーム通知作成
    [self alarmNotification];
    
    /* PUSH通知作成判断
    if ([self.viewController DTPushMakeCalc])
    {
        // BackgroundでのPush通知登録実施
        [self.viewController PushCreateInBackgroundTask];
    }
    */
}



#pragma mark 【Delegate】WillEnterForeground時の処理
- (void)applicationWillEnterForeground
{
    DLog();
    
    // 広告定期ロード判断
    [self adViewResume];
    
#pragma mark -【GA】回帰起動
    GA_TRACK_EVENT(@"総起動", @"回帰起動", @"", nil);
}




// ユーザ・デフォルトの読み込みと画面同期
- (void)viewWillAppear:(BOOL)animated
{
    DLog();
    [super viewWillAppear:animated];
    
#pragma mark -【Alarm】initialize
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle]pathForResource:[userdefaults stringForKey:@"Sound Name"] ofType:@"aif"];
    NSURL *url = [NSURL fileURLWithPath:path];
    alarmPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; //マナーモード無効
    alarmPlayer.numberOfLoops = -1; //ループ再生

    // ユーザ・デフォルトの読み込み
    [self loadUserDefaults];
    
    // 画面同期
    [self setAlarmItems];
    
    // 下部広告ロード再開
    [self.nadView2 resume];
    DLog(@"\n\n[NADVIEW UNDER]:RESUME\n\n");
    
    
    // 画面遷移時の広告定期ロード判断
    if ([userdefaults boolForKey:@"AD VIEW HOME-middle"])
    {
        // 中央広告定期ロードを再開
        [self.nadView1 resume];
        DLog(@"\n\n[NADVIEW HOME]:RESUME\n\n");
    }
    
    /* iOS8以上でのLocal通知認証処理 */
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
        if (![userdefaults boolForKey:@"Notif Useflag"]) {
            
            /* 初回通知認証 */
            // 通知を許可するよう事前にアラートで告知
            NSString *NotifStartTitle = NSLocalizedString(@"NotifStartTitle", nil);
            NSString *NotifStartStr = NSLocalizedString(@"NotifStartStr", nil);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NotifStartTitle
                                                           message:NotifStartStr
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
            [alert show];
            
            // 初回通知確認フラグ解除
            [userdefaults setBool:YES forKey:@"Notif Useflag"];
            [userdefaults synchronize];
            DLog(@"\n\n[NOTIF FIRSTFLAG]:%d\n\n", [userdefaults boolForKey:@"Notif Useflag"]);
        }
    }
    
#pragma mark -【GA】ホーム画面
    self.screenName = @"ホーム画面";
    GA_TRACK_PAGE(self.screenName);
}


#pragma mark - iOS8/通知初回認証
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DLog(@"\n\n[BUTTON INDEX]:%ld\n[OS VERSION]:%@\n\n", (long)buttonIndex,[[UIDevice currentDevice] systemVersion]);
    if (buttonIndex == 0)
    {
        /* iOS8以上でのLocal通知認証処理 */
        UIUserNotificationType types = UIUserNotificationTypeSound |
                                       UIUserNotificationTypeBadge |
                                       UIUserNotificationTypeAlert;
        
        UIUserNotificationSettings *Settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:Settings];
        
    }
}

#pragma mark -【Alarm】タイマー
-(void)driveClock:(NSTimer *)timer
{
    //ユーザ・デフォルトの読み込み
    [self loadUserDefaults];
    
    // 現在日時,年,曜日の取得
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned nowFlags = NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:nowFlags fromDate:today];
    int hour = (int)[todayComponents hour];
    int min = (int)[todayComponents minute];
    
    // アラームまでの残り時間計算
    remainHour = alarmHour - hour;
    remainMin = alarmMin - min;
    if (remainHour <= 0 && remainMin < 0) {
        remainMin = remainMin + 60;
        remainHour = remainHour + 23;
    }
    else if (remainHour < 0 && remainMin >= 0) {
        remainHour = remainHour + 24;
    }
    else if (remainHour > 0 && remainMin < 0) {
        remainMin = remainMin + 60;
        remainHour = remainHour - 1;
    }
    else if (remainHour == 0 && remainMin == 0 && wakeUp == YES)
    {
        remainHour = 24;
        remainMin = 0;
    }
    
    //デザイン適用処理
    //年月日とremainを一つの文字列へ結合
    NSDateFormatter *df1 = [[NSDateFormatter alloc]init];
    [df1 setCalendar:calendar];
    [df1 setLocale:[NSLocale systemLocale]];
    [df1 setTimeZone:[NSTimeZone systemTimeZone]];
    [df1 setDateFormat:@"yyyyMMddHHmm"];
    NSString *dateString = [NSString stringWithFormat:@"%@%02d%02d", [df1 stringFromDate:today], remainHour, remainMin];
    
    NSMutableArray *number = [NSMutableArray array]; //Imageのファイルパス格納用の配列を生成
    for (int i = 0; i < 16; i++)
    {
        if(i < 8 || i > 11)
        {
            char num = [dateString characterAtIndex:i]; //i番目の文字を抽出
            NSString *imagePath = [NSString stringWithFormat:@"font1_%c.png", num]; //抽出した文字(数字)のImage画像ファイルパスを生成
            [number insertObject:imagePath atIndex:i]; //配列のi番目に生成したImage画像ファイルパスを格納
        }
        else
        {
            char num = [dateString characterAtIndex:i]; //i番目の文字を抽出
            NSString *imagePath = [NSString stringWithFormat:@"font2_%c.png", num]; //抽出した文字(数字)のImage画像ファイルパスを生成
            [number insertObject:imagePath atIndex:i]; //配列のi番目に生成したImage画像ファイルパスを格納
        }
    }
    // 画像の割当
    self.yearNum1.image = [UIImage imageNamed:number[0]];
    self.yearNum2.image = [UIImage imageNamed:number[1]];
    self.yearNum3.image = [UIImage imageNamed:number[2]];
    self.yearNum4.image = [UIImage imageNamed:number[3]];
    self.monthNum1.image = [UIImage imageNamed:number[4]];
    self.monthNum2.image = [UIImage imageNamed:number[5]];
    self.dateNum1.image = [UIImage imageNamed:number[6]];
    self.dateNum2.image = [UIImage imageNamed:number[7]];
    self.hourNum1.image = [UIImage imageNamed:number[8]];
    self.hourNum2.image = [UIImage imageNamed:number[9]];
    self.minNum1.image = [UIImage imageNamed:number[10]];
    self.minNum2.image = [UIImage imageNamed:number[11]];
    self.remainHour1.image = [UIImage imageNamed:number[12]];
    self.remainHour2.image = [UIImage imageNamed:number[13]];
    self.remainMin1.image = [UIImage imageNamed:number[14]];
    self.remainMin2.image = [UIImage imageNamed:number[15]];
    
    
    //試聴音再生判断
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults boolForKey:@"Sound Test"])
    {
        //試聴フラグONなら試聴開始
        if (alarmPlayer.playing == NO && testPlayer.playing == NO)
        {
            //アラーム再生がなければ、試聴開始
            testSoundName = [userdefaults stringForKey:@"Sound Name"];
            NSString *path = [[NSBundle mainBundle]pathForResource:[userdefaults stringForKey:@"Sound Name"] ofType:@"aif"];
            NSURL *url = [NSURL fileURLWithPath:path];
            testPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; //マナーモード無効
            MPMusicPlayerController *musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
            [musicPlayerController setVolume: 0.3f];
            testPlayer.volume = 1.0f;
            testPlayer.numberOfLoops = 0;
            [testPlayer play];
            DLog(@"\n\n[TEST PLAY]:START\n[SOUND NAME]:%@\n\n", [userdefaults stringForKey:@"Sound Name"]);
        }
        else if ((alarmPlayer.playing == YES || [[userdefaults objectForKey:@"Test Date"] timeIntervalSinceDate:today] <= 0) && testPlayer.playing == YES)
        {
            //アラーム再生 or 5秒後なら、試聴停止
            [testPlayer stop];
            [userdefaults setBool:NO forKey:@"Sound Test"];
            [userdefaults synchronize];
            DLog(@"\n\n[TEST PLAY]:STOP\n[REASON]:\nalarmPlayer.playing = %d\ntime = %f\n\n", alarmPlayer.playing, [[userdefaults objectForKey:@"Test Date"] timeIntervalSinceDate:today]);
        }
        else if (testPlayer.playing == YES)
        {
            if (testSoundName != [userdefaults stringForKey:@"Sound Name"])
            {
                //再生途中で別のサウンドを選択した場合は、一度ストップ
                [testPlayer stop];
                DLog(@"\n\n[TEST PLAY]:PAUSE\ntestSoundName:%@\nudsoundName:%@", testSoundName, [userdefaults stringForKey:@"Sound Name"]);
            }
        }
    }
    
    // アラーム音再生判断
    if (alarmEnabled)
    {
        // 現在時刻の秒数の情報を切り捨てて、”HH:mm”形式に変換
        NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
        [df2 setCalendar:calendar];
        [df2 setLocale:[NSLocale systemLocale]];
        [df2 setTimeZone:[NSTimeZone systemTimeZone]];
        [df2 setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *dateString = [df2 stringFromDate:today];
        today = [df2 dateFromString:dateString];
        
        float interval = -1800; //アラーム有効時間、30分
        
        if ([alarmTime timeIntervalSinceDate:today] == 0 && wakeUp == NO && alarmPlayer.playing == NO) //アラーム時刻が現在時刻と同じかつシェイク未達成時
        {
            if (self.presentedViewController != nil)
            {
                // Settings画面が表示されていた場合は、強制的に画面遷移
                [self SettingsViewControllerDidFinish:[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil]];
            }
            
            if ([userdefaults boolForKey:@"AD VIEW HOME-middle"]) // 広告が表示されていた場合
            {
                // アラーム開始で広告削除
                [self BannerViewDelete];
            }
            
            //最大音量に設定
            MPMusicPlayerController *musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
            [musicPlayerController setVolume: 1.0f];
            alarmPlayer.volume = 1.0f;
            [alarmPlayer play];
            shakeNumber = 50;
            self.shakeNum1.image = [UIImage imageNamed:@"font3_5.png"];
            self.shakeNum2.image = [UIImage imageNamed:@"font3_0.png"];
            self.shakeNum1.alpha = 1;
            self.shakeNum2.alpha = 1;
            self.shakeLabel.alpha = 1;
        }
        else if ([alarmTime timeIntervalSinceDate:today] < 0 && wakeUp == NO && notif == YES && alarmPlayer.playing == NO) //アラーム時刻が現在時刻より過去 かつ シェイク未達成時 かつ 通知がある場合
        {
            if ([alarmTime timeIntervalSinceDate:today] >= interval) //アラーム時刻から30分以内かどうか
            {
                if (self.presentedViewController != nil)
                {
                    // Settings画面が表示されていた場合は、強制的に画面遷移
                    [self SettingsViewControllerDidFinish:[[SettingsViewController alloc]initWithNibName:@"SettingsViewController" bundle:nil]];
                }
                
                if ([userdefaults boolForKey:@"AD VIEW HOME-middle"]) // 広告が表示されていた場合
                {
                    // アラーム開始で広告削除
                    [self BannerViewDelete];
                }
                
                //最大音量に設定
                MPMusicPlayerController *musicPlayerController = [MPMusicPlayerController applicationMusicPlayer];
                [musicPlayerController setVolume: 1.0f];
                alarmPlayer.volume = 1.0f;
                [alarmPlayer play];
                shakeNumber = 50;
                self.shakeNum1.image = [UIImage imageNamed:@"font3_5.png"];
                self.shakeNum2.image = [UIImage imageNamed:@"font3_0.png"];
                self.shakeNum1.alpha = 1;
                self.shakeNum2.alpha = 1;
                self.shakeLabel.alpha = 1;
            }
            else
            {
                [self alarmSet]; //アラーム時刻から30分以上経過している場合はOFFに
            }
        }
        else if (alarmPlayer.playing)
        {
            if ([alarmTime timeIntervalSinceDate:today] < interval) //アラーム時刻から30分以上経過している場合はOFFに
            {
                [alarmPlayer stop];
                self.shakeNum1.alpha = 0; // シェイク回数を非表示に
                self.shakeNum2.alpha = 0; // シェイク回数を非表示に
                self.shakeNum3.alpha = 0; // シェイク回数を非表示に
                self.shakeLabel.alpha = 0; // shake!の文字を非表示に
                self.SetButton.enabled = YES; // シェイク達成でSetbutton無効解除
                self.swipeGestureRecognizer.enabled = YES; // スワイプジェスチャー検知を有効
                [motionManager stopAccelerometerUpdates]; // シェイク検出終了
    
                [self alarmSet]; // アラームOFF
                
                if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
                {
                    // Push IDを初期化
                    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
                    [userdefaults setValue:@"" forKey:@"Push ID"];
                    //シェイク達成でDT:OFF (暫定)
                    [userdefaults setBool:NO forKey:@"DT Enabled"];
                    [userdefaults synchronize];
                }
            }
            else
            {
                if (self.SetButton.enabled == YES && motionManager.accelerometerActive == NO)
                {
                    // アラーム再生中はSetbutton無効
                    self.SetButton.enabled = NO;
                    // スワイプジェスチャー検知を無効
                    self.swipeGestureRecognizer.enabled = NO;
                    [self startShake];
                }
            }
        }
    }
}


#pragma mark -【Shake】initialize
- (void)startShake
{

#pragma mark -【GA】アラーム再生
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"HH:mm"];
    NSString *dateString = [df stringFromDate:alarmTime];
    GA_TRACK_EVENT(@"アラーム", @"アラーム再生", dateString, nil);
#pragma mark -【GA】サウンド名
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *soundStr = [userdefaults stringForKey:@"Sound Name"];
    GA_TRACK_EVENT(@"サウンド", soundStr, nil, nil);
    
    motionManager = [[CMMotionManager alloc]init];
    //加速度センサーの計測インターバル
    motionManager.accelerometerUpdateInterval = 0.2;
    CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
    {
        [self shake:data];
    };
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    
}

#pragma mark -【Shake】Start
- (void)shake:(CMAccelerometerData *)data
{
    double accx = data.acceleration.x;
    double accy = data.acceleration.y;
    double accz = data.acceleration.z;
    double total = fabs(accx) + fabs(accy) + fabs(accz);
    
    if (shakeNumber > 10) //残りシェイク数が2桁の時
    {
        if (total >= 1.9)
        {
            shakeNumber = --shakeNumber;
            NSString *shakeNum = [NSString stringWithFormat:@"%02d", shakeNumber];
            char num1 = [shakeNum characterAtIndex:0];
            char num2 = [shakeNum characterAtIndex:1];
            self.shakeNum1.image = [UIImage imageNamed:[NSString stringWithFormat:@"font3_%c.png", num1]];
            self.shakeNum2.image = [UIImage imageNamed:[NSString stringWithFormat:@"font3_%c.png", num2]];
        }
    }
    else if (shakeNumber <= 10 && shakeNumber != 0) //残りシェイク数が一桁の時
    {
        if (total >= 1.9)
        {
            shakeNumber = --shakeNumber;
            self.shakeNum1.alpha = 0;
            self.shakeNum2.alpha = 0;
            self.shakeNum3.image = [UIImage imageNamed:[NSString stringWithFormat:@"font3_%d.png", shakeNumber]];
            self.shakeNum3.alpha = 1;
        }
    }
    else if (shakeNumber == 0) //シェイク達成時の処理
    {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        [alarmPlayer stop];
        self.shakeNum3.alpha = 0; // シェイク回数を非表示に
        self.shakeLabel.alpha = 0; // shake!の文字を非表示に
        notif = NO;
        wakeUp = YES;
        [self saveUserDefaults];
        self.SetButton.enabled = YES; // シェイク達成でSetbutton無効解除
        self.swipeGestureRecognizer.enabled = YES; // スワイプジェスチャー検知を有効
        [motionManager stopAccelerometerUpdates]; // シェイク検出終了
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
#pragma mark -【ad】広告表示
        if ([userdefaults boolForKey:@"AD MIDDLE LOAD"])
        {
            // シェイク達成で広告表示
            [self performSelector:@selector(BannerViewAppear) withObject:nil afterDelay:0.7];
            // ⇒viewdidloadで[self.nadview load]し、シェイク達成で広告枠表示に変更
        }


        if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
        {
            // Push IDを初期化
            [userdefaults setValue:@"" forKey:@"Push ID"];
            //シェイク達成でDT:OFF (暫定)
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults synchronize];
        }
        
#pragma mark -【GA】シェイク達成
        GA_TRACK_EVENT(@"シェイク", @"シェイク達成", @"", nil);

#pragma mark -【GA】ディスパッチ
        // 並列なキュー(global_queue)で非同期(async)、優先度中(DISPATCH_QUEUE_PRIORITY_DEFAULT)
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue,
                       ^{
                           [[GAI sharedInstance] dispatch];
                       });
    }
}


#pragma mark -【ad】初回ロード成功
- (void)nadViewDidFinishLoad:(NADView *)adView
{
    /*中央広告*/
    // 初回ロードが完了したら定期ロードを中断(シェイク達成で表示＆定期ロード再開)
    [self.nadView1 pause];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"AD MIDDLE LOAD"];
    [userDefaults synchronize];
    DLog(@"\n\n[NADVIEW]:初回ロード\n[MEDDLE LOAD]:%d\n[NADVIEW HOME-middle]:PAUSE\n\n",[userDefaults boolForKey:@"AD MIDDLE LOAD"]);
    
    
    /*下部広告*/
    if ([userDefaults boolForKey:@"Tutorial View"])
    {
        //チュートリアル画面なしなら広告を表示
        [self.view addSubview:self.nadView2];
        [userDefaults setBool:YES forKey:@"AD VIEW HOME-under"];
        [userDefaults setBool:YES forKey:@"AD UNDER LOAD"];
        [userDefaults synchronize];
        DLog(@"\n\n[UNDER LOAD]:%d\n[NADVIEW HOME-under]:表示 %d\n\n", [userDefaults boolForKey:@"AD UNDER LOAD"], [userDefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    else
    {
        //チュートリアル画面ありなら広告を非表示
        [userDefaults setBool:YES forKey:@"AD UNDER LOAD"];
        [userDefaults synchronize];
        DLog(@"\n\n[UNDER LOAD]:%d\n[NADVIEW HOME-under]:非表示 %d\n\n", [userDefaults boolForKey:@"AD UNDER LOAD"], [userDefaults boolForKey:@"AD VIEW HOME-under"]);
    }

}
 
#pragma mark -【ad】ロード成功(初回以降)
- (void)nadViewDidReceiveAd:(NADView *)adView
{
    DLog(@"\n\n[NADVIEW]:定期ロード\n\n");
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    /*中央広告*/
    if (![userDefaults boolForKey:@"AD MIDDLE LOAD"])
    {
        // 広告のロードが成功していない場合、成功フラグをON
        [userDefaults setBool:YES forKey:@"AD MIDDLE LOAD"];
        [userDefaults synchronize];
        DLog(@"\n\n[NADVIEW LOAD]:%d\n\n",[userDefaults boolForKey:@"AD MIDDLE LOAD"]);
    }
    
    /*下部広告*/
    if (![userDefaults boolForKey:@"AD VIEW HOME-under"])
    {
        // 広告が表示されていない場合
        if ([userDefaults boolForKey:@"Tutorial View"])
        {
            //チュートリアル画面なしなら広告を表示
            [self.view addSubview:self.nadView2];
            [userDefaults setBool:YES forKey:@"AD VIEW HOME-under"];
            [userDefaults setBool:YES forKey:@"AD UNDER LOAD"];
            [userDefaults synchronize];
            DLog(@"\n\n[UNDER LOAD]:%d\n[NADVIEW HOME-under]:表示 %d\n\n", [userDefaults boolForKey:@"AD UNDER LOAD"], [userDefaults boolForKey:@"AD VIEW HOME-under"]);
        }
        else
        {
            //チュートリアル画面ありなら広告を非表示
            [userDefaults setBool:YES forKey:@"AD UNDER LOAD"];
            [userDefaults synchronize];
            DLog(@"\n\n[UNDER LOAD]:%d\n[NADVIEW HOME-under]:非表示 %d\n\n", [userDefaults boolForKey:@"AD UNDER LOAD"], [userDefaults boolForKey:@"AD VIEW HOME-under"]);
        }
    }
    
}

#pragma mark -【ad】広告表示メソッド
- (void)BannerViewAppear
{
    [self.nadView1 resume]; // 広告の定期ロードを再開
    [self.view addSubview:self.nadView1]; // 広告の表示
    [self.view addSubview:closeButton]; // Closeボタンの表示
    [self.view addSubview:buttonTitle]; //Closeラベルの表示
    self.SetButton.enabled = NO; // メガネボタンの無効
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"AD VIEW HOME-middle"];
    [userDefaults synchronize];
    DLog(@"\n\n[NADVIEW HOME-middle]:表示 %d\n[NAD VIEW HOME-middle]:RESUME\n\n", [userDefaults boolForKey:@"AD VIEW HOME-middle"]);
}

#pragma mark -【ad】広告クリック
- (void)nadViewDidClickAd:(NADView *)adView
{
    [self.nadView1 pause]; // 広告の定期ロードを中断
    DLog(@"\n\n[NADVIEW HOME-middle]:PAUSE\n\n");
    
    [self BannerViewDelete]; // 広告の削除
}

#pragma mark -【ad】ロード失敗
- (void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    /*中央広告*/
    [userDefaults setBool:NO forKey:@"AD MIDDLE LOAD"];
    [userDefaults synchronize];
    DLog(@"\n\n[NADVIEW LOAD]:%d\n\n",[userDefaults boolForKey:@"AD MIDDLE LOAD"]);
    
    if ([userDefaults boolForKey:@"AD VIEW HOME-middle"])
    {
        [self BannerViewDelete]; // 広告の削除
    }
    
    /*下部広告*/
    DLog(@"\n\n[NADVIEW HOME-under]:受信エラー\n\n");
    
    if ([userDefaults boolForKey:@"AD VIEW HOME-under"])
    {
        // 表示されていた場合、広告を削除
        [self.nadView2 removeFromSuperview];
        [userDefaults setBool:NO forKey:@"AD VIEW HOME-under"];
        [userDefaults synchronize];
        
        DLog(@"\n\n[NADVIEW HOME-under]:削除 %d\n\n", [userDefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    
}

#pragma mark -【ad】広告削除メソッド
- (void)BannerViewDelete
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.nadView1 removeFromSuperview]; // 広告のviewを削除
    [closeButton removeFromSuperview]; // Closeボタンを削除
    [buttonTitle removeFromSuperview]; // Closeラベルを削除
    self.SetButton.enabled = YES; // メガネボタンを有効に
    
    [userDefaults setBool:NO forKey:@"AD VIEW HOME-middle"];
    [userDefaults synchronize];
    
    DLog(@"\n\n[NADVIEW HOME-middle]:削除 %d\n\n", [userDefaults boolForKey:@"AD VIEW HOME-middle"]);
}

#pragma mark -【ad】Closeボタンタップ
- (void)buttonBannerClose:(UIButton *)sender
{
    [self.nadView1 pause]; // 広告の定期ロードを中断
    DLog(@"\n\n[NADVIEW HOME-middle]:PAUSE\n\n");
    
    [self BannerViewDelete]; // 広告の削除
}

#pragma mark -【ad】バックグラウンド移行時
- (void)adViewPause
{
     /*中央広告*/
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"AD VIEW HOME-middle"]) // 広告が表示されている場合
    {
        [self.nadView1 pause]; // 中央広告の定期ロードを中断
        DLog(@"\n\n[NADVIEW HOME-middle]:PAUSE\n\n");
    }
    
    
    /*下部広告*/
    [self.nadView2 pause]; // 下部広告の定期ロードを中断
    DLog(@"\n\n[NADVIEW HOME-under]:PAUSE\n\n");
}

#pragma mark -【ad】バックグラウンド復帰時
- (void)adViewResume
{
    /*中央広告*/
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"AD VIEW HOME-middle"]) // 広告が表示されている場合
    {
        [self.nadView1 resume]; // 広告の定期ロードを再開
        DLog(@"\n\n[NADVIEW HOME-middle]:RESUME\n\n");
    }
    
    /*下部広告*/
    [self.nadView2 resume]; // 下部広告の定期ロードを再開
    DLog(@"\n\n[NADVIEW HOME-under]:RESUME\n\n");
}



#pragma mark -【Alarm】時刻設定開始
- (void)alarmEdit
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // 現在の年,月,日の取得
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned nowFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:nowFlags fromDate:today];
    int year = (int)[todayComponents year];
    int month = (int)[todayComponents month];
    int day = (int)[todayComponents day];
    
    // DatePicker起動時の日時インスタンスを生成
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [NSString stringWithFormat:@"%d/%02d/%02d %02d:%02d", year,month,day,alarmHour,alarmMin];
    NSDate *datepickerDate = [df dateFromString:dateString];
    
    // 下部広告の削除
    if ([userDefaults boolForKey:@"AD VIEW HOME-under"])
    {
        // 表示されていた場合、広告を削除
        [self.nadView2 pause];
        [self.nadView2 removeFromSuperview];
        [userDefaults setBool:NO forKey:@"AD VIEW HOME-under"];
        [userDefaults synchronize];
        
        DLog(@"\n\n[NADVIEW HOME-under]:削除 %d\n\n", [userDefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    
    // DatePicker&ToolBar画面の表示
    self.DatePicker.date = datepickerDate;
    _DatePicker.alpha = 1;
    _Toolbar.alpha = 1;
    CGRect TimePickerFrame = self.DatePicker.frame;
    CGRect ToolbarFrame = self.Toolbar.frame;
    TimePickerFrame.origin.y = self.view.frame.size.height+20 - self.DatePicker.frame.size.height;
    ToolbarFrame.origin.y = self.view.frame.size.height+20 - self.DatePicker.frame.size.height - self.Toolbar.frame.size.height;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.DatePicker.frame = TimePickerFrame;
                     }];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.Toolbar.frame = ToolbarFrame;
                     }];
}


#pragma mark -【Alarm】時刻設定
- (IBAction)didDoneButtonClicked:(id)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    alarmTime = self.DatePicker.date; // DatePickerで選択した時間をアラーム時刻へ代入
    
    // alarmTime秒数の情報を切り捨てて、”HH:mm”形式に変換
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *alarmString = [df stringFromDate:alarmTime];
    alarmTime = [df dateFromString:alarmString];
    
    // アラームの時・分を取得
//    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned alarmFlags = NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *alarmComponents = [calendar components:alarmFlags fromDate:alarmTime];
    alarmHour = (int)[alarmComponents hour];
    alarmMin = (int)[alarmComponents minute];
    
    // DatePickerをアニメーションで非表示に
    CGRect TimePickerFrame = self.DatePicker.frame;
    CGRect ToolbarFrame = self.Toolbar.frame;
    TimePickerFrame.origin.y = self.view.frame.size.height+20;
    ToolbarFrame.origin.y = self.view.frame.size.height+20;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.DatePicker.frame = TimePickerFrame;
                     }];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.Toolbar.frame = ToolbarFrame;
                     }];
    // アニメーション完了後にalpha調整
    [self performSelector:@selector(alpha)
               withObject:nil afterDelay:0.5];

    wakeUp = NO;
    notif = NO;
    
    // アラームの状態を反転
    alarmEnabled = !alarmEnabled;
    
    //ユーザ・デフォルトの更新
    [self saveUserDefaults];
    
    
    /* remainの表示 */
    CGRect remainLabelFrame = self.remainLabel.frame;
    CGRect remainTimeFrame = self.remainTimeView.frame;
    // 3.5inch,4inch以上両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        remainLabelFrame.origin.x = 244;
        remainTimeFrame.origin.x = 231;
    }
    else
    {
        remainLabelFrame.origin.x = 224;
        remainTimeFrame.origin.x = 211;
    }
    [UIView animateWithDuration:0.7
                     animations:^{
                         self.remainLabel.frame = remainLabelFrame;
                     }];
    [UIView animateWithDuration:1
                     animations:^{
                         self.remainTimeView.frame = remainTimeFrame;
                     }];
    
    // ビューを更新
    [self setAlarmItems];
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        if ([userdefaults boolForKey:@"DT Enabled"])
        {
            // DT:ONならPush通知を登録
            [self dtPushMake];
        }
    }
    
    
    // 下部広告の表示
    if ([userdefaults boolForKey:@"AD UNDER LOAD"])
    {
        // ロード成功済みなら広告表示
        [self.nadView2 resume]; //ロード再開
        [self.view addSubview:self.nadView2];
        [userdefaults setBool:YES forKey:@"AD VIEW HOME-under"];
        DLog(@"\n\n[NADVIEW HOME-under]:表示 %d\n\n", [userdefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    
#pragma mark -【GA】アラームON
    GA_TRACK_EVENT(@"メガネタップ", @"アラームON", @"", nil);
    
}






#pragma mark -【Nifty Baas】Push通知生成
-(void)dtPushMake
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    //アラーム時刻と現在時刻をチェック
    NSDate *today = [NSDate date];
    NSDate *alarmDate = [userdefaults objectForKey:@"Alarm Date"];
    NSDate *deliveryTime;
    if ([alarmDate timeIntervalSinceDate:today] < 0)
    {
        //alarmTimeが過去の場合は、翌日に変換
        deliveryTime = [NSDate dateWithTimeInterval:86400 sinceDate:alarmDate];
    }
    else
    {
        //alarmTimeが未来の場合は、そのまま
        deliveryTime = alarmDate;
    }
    
    // Push IDを生成
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *todayStr = [df stringFromDate:today];
    NSString *deliveryStr = [df stringFromDate:deliveryTime];
    NSString *pushID = [todayStr stringByAppendingString:deliveryStr];
    
    // ユーザデフォルトに保存
    [userdefaults setValue:pushID forKey:@"Push ID"];
    [userdefaults synchronize];
    
    // dvTokenIDを取得
    NSString *dvTokenID = [userdefaults stringForKey:@"dvTokenID"];
    
    // Push通知生成
    NCMBPush *push = [[NCMBPush alloc] init];
    NCMBQuery *query = [NCMBInstallation query];
    
//    NSDictionary *data = @{@"contentAvailable":[NSNumber numberWithBool:YES],
//                           @"badgeIncrementFlag":[NSNumber numberWithBool:NO]};
    
    NSDictionary *userinfo = @{@"pushID":pushID};
    
    [query whereKey:@"deviceToken" equalTo:dvTokenID];
    [push setSearchCondition:query];
//    [push setData:data];
    [push setBadgeIncrementFlag:NO];
    [push setContentAvailable:YES];
    [push setUserSettingValue:userinfo];
    [push setDeliveryTime:[NSDate dateWithTimeInterval:3*60 sinceDate:deliveryTime]];
    [push setPushToIOS:true];
    //    [push clearExpiration];
    [push sendPushInBackgroundWithBlock:^(NSError *error)
     {
         if (error == nil){
             DLog(@"\n\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", [NSDate dateWithTimeInterval:540*60 sinceDate:alarmDate], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
         }else{
             DLog(@"\n\n[ALARM DATE]:%@\n[PUSH SEND]:ERROR\n[ERROR DETAIL]:%@\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", [NSDate dateWithTimeInterval:540*60 sinceDate:alarmDate], error, pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
         }
     }];
    
}


#pragma mark -【Alarm】時刻設定キャンセル
- (IBAction)didCancelButtonClicked:(id)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // DatePickerをアニメーションで非表示に
    CGRect TimePickerFrame = self.DatePicker.frame;
    CGRect ToolbarFrame = self.Toolbar.frame;
    TimePickerFrame.origin.y = self.view.frame.size.height+20;
    ToolbarFrame.origin.y = self.view.frame.size.height+20;
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.DatePicker.frame = TimePickerFrame;
                     }];
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.Toolbar.frame = ToolbarFrame;
                     }];
    
    // アニメーション完了後にalpha調整
    [self performSelector:@selector(alpha)
               withObject:nil afterDelay:0.5];
    
    // 下部広告の表示
    if ([userdefaults boolForKey:@"AD UNDER LOAD"])
    {
        // ロード成功済みなら広告表示
        [self.nadView2 resume]; //ロード再開
        [self.view addSubview:self.nadView2];
        [userdefaults setBool:YES forKey:@"AD VIEW HOME-under"];
        DLog(@"\n\n[NADVIEW HOME-under]:表示 %d\n\n", [userdefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    
#pragma mark -【GA】キャンセル
    GA_TRACK_EVENT(@"メガネタップ", @"キャンセル", @"", nil);
}

#pragma mark -【Alarm】Datepicker非表示
- (void)alpha
{
    _DatePicker.alpha = 0;
    _Toolbar.alpha = 0;
}


#pragma mark -【Alarm】ON/OFF
- (IBAction)alarmSet
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // アラーム状態がオフの時は、アラーム設定処理開始
    if (alarmEnabled == NO)
    {
        DLog(@"\n\n[DEVICE  OS VERSION]:%f\n[iOS7_1_VERSION]:%f\n\n",floor(NSFoundationVersionNumber), NSFoundationVersionNumber_iOS_7_1);
        /* iOS8以上での通知認証確認 */
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types < (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)){
                
                // 通知未許可ならアラートで告知
                NSString *NotifSettingTitle = NSLocalizedString(@"NotifSettingTitle", nil);
                NSString *NotifSettingStr = NSLocalizedString(@"NotifSettingStr", nil);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NotifSettingTitle
                                                               message:NotifSettingStr
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"OK", nil];
                [alert show];
                DLog(@"\n\n[OS VERSION]:%@\n[NOTIF FIRSTFLAG]:%d\n[NOTIF STATUS]:%@\n\n", [[UIDevice currentDevice] systemVersion], [userdefaults boolForKey:@"Notif Useflag"],[[UIApplication sharedApplication] currentUserNotificationSettings]);
            }else{
                // アラーム編集画面起動
                DLog(@"\n\n[OS VERSION]:%@\n[NOTIF FIRSTFLAG]:%d\n\n", [[UIDevice currentDevice] systemVersion], [userdefaults boolForKey:@"Notif Useflag"]);
                [self alarmEdit];
            }
        }else{
            // アラーム編集画面起動
            DLog(@"\n\n[OS VERSION]:%@\n[NOTIF FIRSTFLAG]:%d\n\n", [[UIDevice currentDevice] systemVersion], [userdefaults boolForKey:@"Notif Useflag"]);
            [self alarmEdit];
        }
    }
    else
    {
        //ローカル通知の初期化（過去のローカル通知を削除する）
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        notif = NO;
        wakeUp = YES;
        
        // アラームの状態を反転
        alarmEnabled = !alarmEnabled;
        
        //ユーザ・デフォルトの更新
        [self saveUserDefaults];
        
        // ビューを更新
        [self setAlarmItems];
        
#pragma mark -【GA】アラームOFF
        GA_TRACK_EVENT(@"メガネタップ", @"アラームOFF", @"", nil);
    }
    
    
}


// 状態別の画面設定
- (void)setAlarmItems
{
    // AlarmのON/OFF毎の表示設定
    if (alarmEnabled)
    {
        self.meganeicon.alpha = 1;
        // remainの表示
        CGRect remainLabelFrame = self.remainLabel.frame;
        CGRect remainTimeFrame = self.remainTimeView.frame;
        
        // 3.5inch,4inch以上両対応
        CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
        if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
        {
            remainLabelFrame.origin.x = 244;
            remainTimeFrame.origin.x = 231;
        }
        else
        {
            remainLabelFrame.origin.x = 224;
            remainTimeFrame.origin.x = 211;
        }
        self.remainLabel.frame = remainLabelFrame;
        self.remainTimeView.frame = remainTimeFrame;
    }
    else
    {
        self.meganeicon.alpha = 0.4;
        // remainの非表示
        CGRect remainLabelFrame = self.remainLabel.frame;
        CGRect remainTimeFrame = self.remainTimeView.frame;
        remainLabelFrame.origin.x = 320;
        remainTimeFrame.origin.x = 320;
        self.remainLabel.frame = remainLabelFrame;
        self.remainTimeView.frame = remainTimeFrame;
    }
    
    // Alarm時間の表示
    NSString *alarmNum = [NSString stringWithFormat:@"%02d%02d", alarmHour, alarmMin];
    char num1 = [alarmNum characterAtIndex:0];
    char num2 = [alarmNum characterAtIndex:1];
    char num3 = [alarmNum characterAtIndex:2];
    char num4 = [alarmNum characterAtIndex:3];
    self.alarmHour1.image = [UIImage imageNamed:[NSString stringWithFormat:@"font1_%c.png", num1]];
    self.alarmHour2.image = [UIImage imageNamed:[NSString stringWithFormat:@"font1_%c.png", num2]];
    self.alarmMin1.image = [UIImage imageNamed:[NSString stringWithFormat:@"font1_%c.png", num3]];
    self.alarmMin2.image = [UIImage imageNamed:[NSString stringWithFormat:@"font1_%c.png", num4]];
    
}


// ユーザ・デフォルトの保存
- (void)saveUserDefaults
{
    // ユーザ・デフォルトを取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:alarmEnabled forKey:@"Alarm Enabled"];
    [userDefaults setBool:notif forKey:@"Notif"];
    [userDefaults setBool:wakeUp forKey:@"Wake Up"];
    [userDefaults setObject:alarmTime forKey:@"Alarm Date"];
    [userDefaults setInteger:alarmHour forKey:@"Alarm Hour"];
    [userDefaults setInteger:alarmMin forKey:@"Alarm Min"];
    
    // ユーザ・デフォルトの保存
    [userDefaults synchronize];
    
}

// ユーザ・デフォルトの読み込み
- (void)loadUserDefaults
{
    // ユーザ・デフォルトの読み込み
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    alarmEnabled = [userDefaults boolForKey:@"Alarm Enabled"];
    notif = [userDefaults boolForKey:@"Notif"];
    wakeUp = [userDefaults boolForKey:@"Wake Up"];
    alarmTime = [userDefaults objectForKey:@"Alarm Date"];
    alarmHour = (int)[userDefaults integerForKey:@"Alarm Hour"];
    alarmMin = (int)[userDefaults integerForKey:@"Alarm Min"];
}



// iphoneの向きはPortrait(縦、標準)のみ許可
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
        return YES;
    else
        return NO;
}


#pragma mark -【Alarm】ローカル通知作成
- (void)alarmNotification
{
    //ローカル通知の初期化（過去のローカル通知を削除する）
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *today = [NSDate date];
    
    // ユーザ・デフォルトを取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    alarmEnabled = [userDefaults boolForKey:@"Alarm Enabled"];
    alarmTime = [userDefaults objectForKey:@"Alarm Date"];
    notif = [userDefaults boolForKey:@"Notif"];
    
    // ローカル通知用サウンドファイル名生成
    NSString *soundName = [userDefaults stringForKey:@"Sound Name"];
    NSString *notifSuffix = @"_Notif.aif";
    NSString *notifSoundName = [NSString stringWithFormat:@"%@%@", soundName, notifSuffix];
    DLog(@"\n\n[NOTIF SOUND NAME]:%@", notifSoundName);
    
    BOOL nigechadame = NO;
    NSString *nigechadameStr = NSLocalizedString(@"nigechadameda", nil);
    
    if (alarmTime == nil)
    {
        return;
    }
    if (alarmEnabled)
    {
        
        // 通知インスタンスを生成
        UILocalNotification *localNotif = [[UILocalNotification alloc]init];
        
        if (notif == NO) //アラーム通知が作成されていない or シェイク達成後
        {
#pragma mark -【GA】通知作成
            GA_TRACK_EVENT(@"ローカル通知", @"通常通知", @"", nil);
            if ([alarmTime timeIntervalSinceDate:today] <= 0) //alarmTimeが現在or過去の場合は、通知時刻を翌日に設定
            {
                alarmTime = [NSDate dateWithTimeInterval:86400 sinceDate:alarmTime];
            }
        }
        else if (notif == YES) //アラーム通知作成済み or シェイク未達成時
        {
            if ([alarmTime timeIntervalSinceDate:today] <= 0) //アラーム通知後シェイク未達成の場合は、即再通知
            {
                alarmTime = [NSDate date];
                nigechadame = YES;
#pragma mark -【GA】シンジ君
                GA_TRACK_EVENT(@"ローカル通知", @"シンジ君", @"", nil);
            }
        }
        // アラーム通知作成
        for (int time = 0; time <= 1800; time += 30)
        {
            localNotif.fireDate = [NSDate dateWithTimeInterval:time sinceDate:alarmTime]; // 通知時刻をアラーム時刻に設定
            localNotif.timeZone = [NSTimeZone localTimeZone]; // タイムゾーンiphoneで設定されているものに
            localNotif.hasAction = YES;
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            unsigned Flags = NSHourCalendarUnit | NSMinuteCalendarUnit;
            NSDateComponents *components = [calendar components:Flags fromDate:localNotif.fireDate];
            int hour = (int)[components hour];
            int min = (int)[components minute];
            
            if (nigechadame)
            {
                localNotif.alertBody = [NSString stringWithFormat:@"%02d:%02d　%@", hour, min, nigechadameStr];
            }
            else
            {
                localNotif.alertBody = [NSString stringWithFormat:@"%02d:%02d", hour,min];
            }
            localNotif.alertAction = @"Open";
            localNotif.soundName = notifSoundName; // 通知時に鳴るアラーム音の設定
            // 通知の登録
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        notif = YES;
        wakeUp = NO;
        // ユーザ・デフォルトに保存
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:alarmTime forKey:@"Alarm Date"];
        [userDefaults setBool:notif forKey:@"Notif"];
        [userDefaults setBool:wakeUp forKey:@"Wake Up"];
        [userDefaults synchronize];
    }
}


#pragma mark -【DT】DT、ACチェック
-(void)dtCheck
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // デラオキツイートONの時は状態チェック
    if ([userdefaults boolForKey:@"DT Enabled"])
    {
        DLog(@"\n\n[DT CHECK STARTED]\n\n");
        
        BOOL notifAllow = YES;
        
        if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
            /* iOS8以上 */
            if ([[UIApplication sharedApplication] currentUserNotificationSettings].types < (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)){
                notifAllow = NO;
                DLog(@"\n\n[OS VERSION]:%@\n[NOTIF ALLOW]:%d\n\n",[[UIDevice currentDevice] systemVersion],notifAllow);
            }
        }else{
            /* iOS7 */
            if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone){
                notifAllow = NO;
                DLog(@"\n\n[OS VERSION]:%@\n[NOTIF ALLOW]:%d\n\n",[[UIDevice currentDevice] systemVersion],notifAllow);
            }
        }
        
        if (!notifAllow)
        {
            // PUSH通知未許可ならDTスイッチOFFでユーザデフォルトに保存 ＆ アラートで告知
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults synchronize];
            NSString *NotifSettingTitle;
            NSString *NotifSettingStr;
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
                NotifSettingTitle = NSLocalizedString(@"NotifSettingTitle", nil);
                NotifSettingStr = NSLocalizedString(@"NotifSettingStr", nil);
            }else{
                NotifSettingTitle = NSLocalizedString(@"PushSettingTitle", nil);
                NotifSettingStr = NSLocalizedString(@"PushSettingStr", nil);
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NotifSettingTitle
                                                           message:NotifSettingStr
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
            [alert show];
            DLog(@"\n\n[DT CHECK]: PUSH DISABLE\n\n");
        }
        else
        {
            // PUSH通知許可済みならアカウント状態をチェック
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            ACAccountType *twAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
            [accountStore requestAccessToAccountsWithType:twAccountType
                                                  options:NULL
                                               completion:^(BOOL granted, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(),
                                ^{
                                    // アカウントの使用が許可されている場合
                                    if (granted)
                                    {
                                        // 状態チェックOK
                                        DLog(@"\n\n[DT CHECK]:OK\n\n");
                                    }
                                    else
                                    {
                                        // アカウントの使用が許可されていないなら、ユーザデフォルトにOFFで保存
                                        [userdefaults setBool:NO forKey:@"DT Enabled"];
                                        [userdefaults setBool:NO forKey:@"AC Enabled"];
                                        [userdefaults synchronize];
                                        
                                        //Accountの使用を許可するようアラートで告知
                                        NSString *twSettingErrorTitle = NSLocalizedString(@"twSettingErrorTitleStr", nil);
                                        NSString *twSettingErrorStr = NSLocalizedString(@"twSettingErrorStr", nil);
                                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:twSettingErrorTitle
                                                                                       message:twSettingErrorStr
                                                                                      delegate:nil
                                                                             cancelButtonTitle:nil
                                                                             otherButtonTitles:@"OK", nil];
                                        [alert show];
                                        DLog(@"\n\n[DT CHECK]: ACCOUNT DISABLE\n[ERROR]:%@\n\n", error);
                                    }
                                });
             }];
        }
    }
    else
    {
        // デラオキツイートOFFの時はスルー
        DLog(@"\n\n[DT CHECK]:DT OFF\n\n");
    }
}






- (void)viewWillDisappear:(BOOL)animated
{
    DLog();
    [super viewWillDisappear:animated];
    
    /*中央広告*/
    if ([self.nadView1 isDescendantOfView:self.view])
    {
        // 中央広告の定期ロードを中断
        [self.nadView1 pause];
        DLog(@"\n\n[NADVIEW HOME-middle]:PAUSE\n\n");
    }
    
    /*下部広告*/
    [self.nadView2 pause]; //下部広告の定期ロードを中断
    DLog(@"\n\n[NADVIEW HOME-under]:PAUSE\n\n");
}


- (void)didReceiveMemoryWarning
{
    DLog();
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    /*中央広告*/
    [self.nadView1 setDelegate:nil]; // delegateにnilをセット
    self.nadView1 = nil; // プロパティ経由でrelease、nilをセット
    
    /*下部広告*/
    [self.nadView2 setDelegate:nil]; // delegateにnilをセット
    self.nadView2 = nil; // プロパティ経由でrelease、nilをセット
    
    // AlarmViewControllerの通知受け取り設定を削除
    [self removeNotificationObserver];
    
    DLog(@"\n\n[self.nadView1.delegate]:%@\n[self.nadView1]:%@\n[self.nadView2.delegate]:%@\n[self.nadView2]:%@\n\n", self.nadView1.delegate, self.nadView1, self.nadView2.delegate, self.nadView2);
}


#pragma mark - 【画面遷移】戻る
- (void)SettingsViewControllerDidFinish:(SettingsViewController *)controller
{
    DLog();
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 【画面遷移】セグエ 識別子とDelegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DLog();
    
    // 識別子をチェックせずに実行する
    [[segue destinationViewController] setDelegate:self];
    
    /*
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
    */
}

#pragma mark - 【View】誘導画面
- (IBAction)batsuButtonClicked // 誘導画面削除
{
    // Tutorial画面の削除
    _tutorialView.alpha = 0;
    [self.tutorialView removeFromSuperview];
    
    // 初期起動フラグを解除
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"Tutorial View"];
    [userDefaults synchronize];
    DLog(@"\n\n[TUTORIAL VIEW]:%d\n\n", [userDefaults boolForKey:@"Tutorial View"]);
    
    
    // 下部広告
    if ([userDefaults boolForKey:@"AD UNDER LOAD"])
    {
        // ロード成功済みなら広告表示
        [self.view addSubview:self.nadView2];
        [userDefaults setBool:YES forKey:@"AD VIEW HOME-under"];
        DLog(@"\n\n[NADVIEW HOME-under]:表示 %d\n\n", [userDefaults boolForKey:@"AD VIEW HOME-under"]);
    }
    
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Debug用メソッド

#pragma mark -【Debug】アラーム停止
- (void)Alarmstop:(UIButton *)sender
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [alarmPlayer stop];
    self.shakeNum1.alpha = 0; // シェイク回数を非表示に
    self.shakeNum2.alpha = 0; // シェイク回数を非表示に
    self.shakeNum3.alpha = 0; // シェイク回数を非表示に
    self.shakeLabel.alpha = 0; // shake!の文字を非表示に
    notif = NO;
    wakeUp = YES;
    [self saveUserDefaults];
    self.SetButton.enabled = YES; // シェイク達成でSetbutton無効解除
    self.swipeGestureRecognizer.enabled = YES; // スワイプジェスチャー検知を有効
    [motionManager stopAccelerometerUpdates]; // シェイク検出終了
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    
    if ([userdefaults boolForKey:@"AD MIDDLE LOAD"])
    {
        // シェイク達成で広告表示
        [self performSelector:@selector(BannerViewAppear) withObject:nil afterDelay:0.7];
        // ⇒viewdidloadで[self.nadview load]し、シェイク達成で広告枠表示に変更
    }
    
    /*
    // 広告の定期ロードを再開
    [self.nadView resume];
    DLog(@"\n\n[NADVIEW HOME]:RESUME\n\n");
    */
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        // Push IDを初期化
        [userdefaults setValue:@"" forKey:@"Push ID"];
        //シェイク達成でDT:OFF (暫定)
        [userdefaults setBool:NO forKey:@"DT Enabled"];
        [userdefaults synchronize];
    }
    
}


#pragma mark -【Debug】Tweet
- (void)TweetTest:(UIButton *)sender
{
    // アカウントを再取得
    ACAccountStore* store = [[ACAccountStore alloc] init];
    ACAccountType* type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray* accounts = [store accountsWithAccountType:type];
    
    // ユーザ・デフォルトからアカウントのIndex番号を取得
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    int index = (int)[userDefaults integerForKey:@"Account Index"];
    
    // TweetWords設定
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
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
                                    #if DEBUG
                                    
                                    NSError *jsonError;
                                    // JSONをパース
                                    NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&jsonError];
                                    
                                    #endif
                                    // responseDataのLog出力
                                    DLog(@"\n\n[TWEET]:Success\n\n[REQUEST ACCOUNT]:%@\n[RESPONSE DATA]\n%@\n\n", [userDefaults stringForKey:@"TW Username"], jsonData);
                                }
                                else
                                {
                                    // 認証エラー、レートリミットオーバーなど
                                    DLog(@"\n\n[TWEET]:Miss\n\n[REQUEST ACCOUNT]:%@\n[JSON ERROR]\n%@\n\n", [userDefaults stringForKey:@"TW Username"], [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
                                }
                            }
                            else
                            {
                                // request自体のエラーをLog出力
                                DLog(@"\n\n[TWEET]:REQUEST ERROR\n\n[REQUEST ACCOUNT]:%@\n[ERROR]\n%@\n\n",[userDefaults stringForKey:@"TW Username"], error);
                            }
                        });
     }];
}


#pragma mark -【Debug】Push通知作成
- (void)PushNotifTest
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // Push IDを生成
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [df setCalendar:calendar];
    [df setLocale:[NSLocale systemLocale]];
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    [df setDateFormat:@"yyyyMMddHHmmss"];
    NSString *todayString = [df stringFromDate:today];
    NSString *alarmString = [df stringFromDate:alarmTime];
    NSString *pushID = [todayString stringByAppendingString:alarmString];
    [userdefaults setValue:pushID forKey:@"Push ID"];
    [userdefaults synchronize];
    
    // dvTokenIDを取得
    NSString *dvTokenID = [userdefaults stringForKey:@"dvTokenID"];
    
    // Push通知生成
    NCMBPush *push = [[NCMBPush alloc] init];
    NCMBQuery *query = [NCMBInstallation query];
    
    NSDictionary *data = @{@"contentAvailable":[NSNumber numberWithBool:YES],
                           @"badgeIncrementFlag":[NSNumber numberWithBool:NO]};
    
    NSDictionary *userinfo = @{@"pushID":pushID};
    
    [query whereKey:@"deviceToken" equalTo:dvTokenID];
    [push setSearchCondition:query];
    [push setData:data];
    [push setUserSettingValue:userinfo];
    [push setDeliveryTime:[NSDate dateWithTimeIntervalSinceNow:1*60]];
    [push setPushToIOS:true];
    //    [push clearExpiration];
    
    [push sendPushInBackgroundWithBlock:^(NSError *error)
     {
         if (error == nil){
                 DLog(@"\n\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", pushID, dvTokenID, [NSDate dateWithTimeIntervalSinceNow:1*60+540*60]);
         }else{
             DLog(@"\n\n[PUSH SEND]:ERROR\n[ERROR DETAL]:%@\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", error, pushID, dvTokenID, [NSDate dateWithTimeIntervalSinceNow:1*60+540*60]);
         }
     }];
}

#pragma mark -【Debug】Tutorial画面表示
- (void)Tutorial
{
    [self.view addSubview:_tutorialView];
    _tutorialView.alpha = 1;
    CGRect tutorialViewframe = _tutorialView.frame;
    tutorialViewframe.origin.x = 0.0;
    _tutorialView.frame = tutorialViewframe;
    
}


@end
