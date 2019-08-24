
#import "AlarmViewController.h"
#import <NCMB/NCMB.h>
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"


@interface AlarmViewController ()

@end

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
    [defaultValues setValue: @(NO) forKey:@"Adview load"];
    [defaultValues setValue: @(NO) forKey:@"Sound Test"];
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
    
    // 日時取得タイマー起動
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(driveClock:) userInfo:nil repeats:YES];
    
    // Date Pickerの初期設定
    self.DatePicker.timeZone = [NSTimeZone systemTimeZone];
    self.DatePicker.backgroundColor = [UIColor whiteColor];
    
    // 自動ロックの禁止
    UIApplication *application = [UIApplication sharedApplication];
    application.idleTimerDisabled = YES;
    
    
#pragma mark -広告表示設定
    // 広告のサイズ
    CGRect iPhone_3_5inch_banner = CGRectMake(10, 88, 320, 250); //3.5inch広告枠サイズ
    CGRect iPhone_3_5inch_close = CGRectMake(89, 344, 143, 28); //3.5inchCloseボタンサイズ
    CGRect iPhone_4inch_banner = CGRectMake(10, 159, 320, 250); //4inch広告枠サイズ
    CGRect iPhone_4inch_close = CGRectMake(89, 417, 143, 38); //4inchCloseボタンサイズ
    
    // 3.5inch,4inch両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_3_5inch_banner]; // 広告枠の生成
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom]; // Closeボタンの生成
        closeButton.frame = iPhone_3_5inch_close; // Closeボタンのサイズ
        buttonTitle = [[UILabel alloc]initWithFrame:iPhone_3_5inch_close]; // Closeボタンタイトルの生成、サイズ
        if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
        {
            // ios7以上なら広告表示位置を調整
            CGRect nadviewframe = _nadView.frame;
            CGRect closebuttonframe = closeButton.frame;
            CGRect buttonTitleframe = buttonTitle.frame;
            nadviewframe.origin.y = _nadView.frame.origin.y + 20.0;
            closebuttonframe.origin.y = closeButton.frame.origin.y + 20.0;
            buttonTitleframe.origin.y = buttonTitle.frame.origin.y + 20.0;
            _nadView.frame = nadviewframe;
            closeButton.frame = closebuttonframe;
            buttonTitle.frame = buttonTitleframe;
        }
    }
    else // それ以外の場合、4inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_4inch_banner]; // 広告枠の生成
        closeButton = [UIButton buttonWithType:UIButtonTypeCustom]; // Closeボタンの生成
        closeButton.frame = iPhone_4inch_close; // Closeボタンのサイズ
        buttonTitle = [[UILabel alloc]initWithFrame:iPhone_4inch_close]; // Closeボタンタイトルの生成、サイズ
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
     320 x 50   a6eca9dd074372c898dd1df549301f277c53f2b9   3172
     320 x100   eb5ca11fa8e46315c2df1b8e283149049e8d235e   70996
     300 x100   25eb32adddc4f7311c3ec7b28eac3b72bbca5656   70998
     300 x250   88d88a288fdea5c01d17ea8e494168e834860fd6   70356
     728 x 90   2e0b9e0b3f40d952e6000f1a8c4d455fffc4ca3a   70999
     アイコン    2349edefe7c2742dfb9f434de23bc3c7ca55ad22    101281
     */
    // apiKey, spotId.の設定
    [self.nadView setNendID:@"ac089c940d1635809fbc5a4beb0def872c38b9b5"
                     spotID:@"128846"];
    //デリゲートはself
    [self.nadView setDelegate:self];
    
//#pragma mark -【GA】Tweet実施カウント
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    if ([userdefaults integerForKey:@"DT Status"] != 0)
//    {
//        // DT実施済みならGA送信
//        if ([userdefaults integerForKey:@"DT Status"] == 1)
//        {
//            // DT成功時
//            DLog(@"\n\n[DT STATUS]:%d  成功\n\n", [userdefaults integerForKey:@"DT Status"]);
//            NSString *twwordsStr;
//            switch ([userdefaults integerForKey:@"TW Words Number"])
//            {
//                case 1:
//                    twwordsStr = NSLocalizedString(@"TWLabel1", nil);
//                    break;
//                case 2:
//                    twwordsStr = NSLocalizedString(@"TWLabel2", nil);
//                    break;
//                case 3:
//                    twwordsStr = NSLocalizedString(@"TWLabel3", nil);
//                    break;
//                case 4:
//                    twwordsStr = NSLocalizedString(@"TWLabel4", nil);
//                    break;
//                case 5:
//                    twwordsStr = NSLocalizedString(@"TWLabel5", nil);
//                    break;
//            }
//            GA_TRACK_EVENT(@"デラオキツイート", @"成功数", twwordsStr, nil);
//            // フラグ初期化
//            [userdefaults setInteger:0 forKey:@"DT Status"];
//            [userdefaults synchronize];
//        }
//        else if ([userdefaults integerForKey:@"DT Status"] == 2)
//        {
//            // DT失敗時
//            DLog(@"\n\n[DT STATUS]:%d  失敗\n\n", [userdefaults integerForKey:@"DT Status"]);
//            NSString *twwordsStr;
//            switch ([userdefaults integerForKey:@"TW Words Number"])
//            {
//                case 1:
//                    twwordsStr = NSLocalizedString(@"TWLabel1", nil);
//                    break;
//                case 2:
//                    twwordsStr = NSLocalizedString(@"TWLabel2", nil);
//                    break;
//                case 3:
//                    twwordsStr = NSLocalizedString(@"TWLabel3", nil);
//                    break;
//                case 4:
//                    twwordsStr = NSLocalizedString(@"TWLabel4", nil);
//                    break;
//                case 5:
//                    twwordsStr = NSLocalizedString(@"TWLabel5", nil);
//                    break;
//            }
//            GA_TRACK_EVENT(@"デラオキツイート", @"失敗数", twwordsStr, nil);
//            // フラグ初期化
//            [userdefaults setInteger:0 forKey:@"DT Status"];
//            [userdefaults synchronize];
//        }
//    }
    
#pragma mark -デバッグビルド時の設定
#if DEBUG
    UIButton *debugButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *tweetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *pushnotifButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [debugButton setTitle:@"Stop" forState:UIControlStateNormal];
    [tweetButton setTitle:@"Tweet" forState:UIControlStateNormal];
    [pushnotifButton setTitle:@"PushN" forState:UIControlStateNormal];
    
    debugButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    tweetButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    pushnotifButton.titleLabel.font = [UIFont boldSystemFontOfSize:19];
    
    debugButton.tintColor = [UIColor blackColor];
    tweetButton.tintColor = [UIColor blackColor];
    pushnotifButton.tintColor = [UIColor blackColor];
    
    if(window.size.height == 480)
    {
        debugButton.frame = CGRectMake(20, 110, 70, 44);
        tweetButton.frame = CGRectMake(125, 110, 70, 44);
        pushnotifButton.frame = CGRectMake(230, 110, 70, 44);
    }
    else
    {
        debugButton.frame = CGRectMake(20, 344, 70, 44);
        tweetButton.frame = CGRectMake(125, 344, 70, 44);
        pushnotifButton.frame = CGRectMake(230, 344, 70, 44);
    }
    
    [debugButton addTarget:self action:@selector(Alarmstop:) forControlEvents:UIControlEventTouchUpInside];
    [tweetButton addTarget:self action:@selector(TweetTest:) forControlEvents:UIControlEventTouchUpInside];
    [pushnotifButton addTarget:self action:@selector(PushNotifTest) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:debugButton];
    [self.view addSubview:tweetButton];
    [self.view addSubview:pushnotifButton];
    
    [self.nadView setIsOutputLog:YES]; // 広告Log出力ON
#else
    [self.nadView setIsOutputLog:NO]; // 広告Log出力OFF
#endif
    
}

// ユーザ・デフォルトの読み込みと画面同期
- (void)viewWillAppear:(BOOL)animated
{
    DLog();
    
#pragma mark -アラーム再生音の設定
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle]pathForResource:[userdefaults stringForKey:@"Sound Name"] ofType:@"aif"];
    NSURL *url = [NSURL fileURLWithPath:path];
    alarmPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil]; //マナーモード無効
    alarmPlayer.numberOfLoops = -1; //ループ再生
    
    // 起動時に広告が表示されていた場合は
    if ([self.nadView isDescendantOfView:self.view])
    {
        [self.nadView resume]; // 広告のロードを再開
    }
    
    // ユーザ・デフォルトの読み込み
    [self loadUserDefaults];
    
    // 画面同期
    [self setAlarmItems];
    
#pragma mark -【GA】ホーム画面
    self.screenName = @"ホーム画面";
    GA_TRACK_PAGE(self.screenName);
    
#pragma mark -【GA】ディスパッチ
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [[GAI sharedInstance] dispatch];
                   });
}

// 日時取得・アラーム再生
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
            NSString *path = [[NSBundle mainBundle] pathForResource:[userdefaults stringForKey:@"Sound Name"] ofType:@"aif"];
            NSURL *url = [NSURL fileURLWithPath:path];
            testPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
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
            [self BannerViewDelete]; // アラーム開始で広告削除
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
                [self BannerViewDelete]; // アラーム開始で広告削除
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
                [self AlarmSet]; //アラーム時刻から30分以上経過している場合はOFFに
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
                [motionManager stopAccelerometerUpdates]; // シェイク検出終了
                [self AlarmSet]; // アラームOFF
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


// シェイク検出開始
- (void)startShake
{
    motionManager = [[CMMotionManager alloc]init];
    //加速度センサーの計測インターバル
    motionManager.accelerometerUpdateInterval = 0.2;
    CMAccelerometerHandler handler = ^(CMAccelerometerData *data, NSError *error)
    {
        [self Shake:data];
    };
    [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:handler];
    
#pragma mark -【GA】アラーム再生
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH:mm"];
    NSString *dateString = [df stringFromDate:alarmTime];
    GA_TRACK_EVENT(@"アラーム", @"アラーム再生", dateString, nil);
#pragma mark -【GA】サウンド名
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    NSString *soundStr = [userdefaults stringForKey:@"Sound Name"];
    GA_TRACK_EVENT(@"サウンド", soundStr, nil, nil);
}

// シェイク検出時の処理
- (void)Shake:(CMAccelerometerData *)data
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
        
        // 広告のロード開始
        [self.nadView load]; // 広告のロードを開始
        
        if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
        {
            // Push IDを初期化
            NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
            [userdefaults setValue:@"" forKey:@"Push ID"];
            //シェイク達成でDT:OFF (暫定)
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults synchronize];
        }
        
#pragma mark -【GA】シェイク達成
        GA_TRACK_EVENT(@"シェイク", @"シェイク達成", @"", nil);
    }
}



// 広告ロード初回成功時の処理
- (void)nadViewDidFinishLoad:(NADView *)adView
{
//    // 0.7秒後に広告を表示
//    [self performSelector:@selector(BannerViewAppear) withObject:nil afterDelay:0.7];
    DLog();
}

 
// 広告受信成功時の処理
- (void)nadViewDidReceiveAd:(NADView *)adView
{
    //アラーム非再生なら、広告を表示
    if (!alarmPlayer.playing)
    {
        // 0.7秒後に広告を表示
        [self performSelector:@selector(BannerViewAppear) withObject:nil afterDelay:0.7];
        DLog();
    }
}

// 広告表示メソッド
- (void)BannerViewAppear
{
    if (![self.nadView isDescendantOfView:self.view]) // 広告が表示されていない場合
    {
        [self.nadView resume]; // 広告の定期ロードを再開
        [self.view addSubview:self.nadView]; // 広告の表示
        [self.view addSubview:closeButton]; // Closeボタンの表示
        [self.view addSubview:buttonTitle]; //Closeラベルの表示
        self.SetButton.enabled = NO; // メガネボタンの無効
        DLog();
    }
}

// 広告クリック時の処理
- (void)nadViewDidClickAd:(NADView *)adView;
{
    [self BannerViewDelete]; // 広告の削除
    DLog();
}

// 広告受信失敗時の処理
- (void)nadViewDidFailToReceiveAd:(NADView *)adView;
{
    [self BannerViewDelete]; // 広告の削除
    DLog();
}

// 広告削除メソッド
- (void)BannerViewDelete
{
    if ([self.nadView isDescendantOfView:self.view]) // 広告が表示されていた場合
    {
        [self.nadView pause]; //広告の定期ロードを中断
        [self.nadView removeFromSuperview]; // 広告のviewを削除
        [closeButton removeFromSuperview]; // Closeボタンを削除
        [buttonTitle removeFromSuperview]; // Closeラベルを削除
        self.SetButton.enabled = YES; // メガネボタンを有効に
    DLog();
    }
}

// Closeボタンタップ時の処理
- (void)buttonBannerClose:(UIButton *)sender
{
    [self BannerViewDelete]; // 広告の削除
    DLog();
}


// Alarm時刻設定開始時の処理
- (void)AlarmEdit
{
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
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *dateString = [NSString stringWithFormat:@"%d/%02d/%02d %02d:%02d", year,month,day,alarmHour,alarmMin];
    NSDate *datepickerDate = [df dateFromString:dateString];
    
    
    // DatePicker&ToolBar画面の表示
    self.DatePicker.date = datepickerDate;
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


// DatePickerでDone時の処理
- (IBAction)didDoneButtonClicked:(id)sender
{
    alarmTime = self.DatePicker.date; // DatePickerで選択した時間をアラーム時刻へ代入
    // alarmTime秒数の情報を切り捨てて、”HH:mm”形式に変換
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSString *alarmString = [df stringFromDate:alarmTime];
    alarmTime = [df dateFromString:alarmString];
    
    // アラームの時・分を取得
    NSCalendar *calendar = [NSCalendar currentCalendar];
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
    wakeUp = NO;
    notif = NO;
    
    // アラームの状態を反転
    alarmEnabled = !alarmEnabled;
    
    //ユーザ・デフォルトの更新
    [self saveUserDefaults];
    
    // remainの表示
    CGRect remainLabelFrame = self.remainLabel.frame;
    CGRect remainTimeFrame = self.remainTimeView.frame;
    remainLabelFrame.origin.x = 224;
    remainTimeFrame.origin.x = 211;
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
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        if ([userdefaults boolForKey:@"DT Enabled"])
        {
            // DT:ONならPush通知を登録
            [self DTPushMake];
        }
    }
    
#pragma mark -【GA】アラームON
    GA_TRACK_EVENT(@"メガネタップ", @"アラームON", @"", nil);
    
}

#pragma mark -【nifty Baas】Push通知生成
-(void)DTPushMake
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];

    //アラーム時刻と現在時刻をチェック
    NSDate *today = [NSDate date];
    NSDate *alarmDate = [userdefaults objectForKey:@"Alarm Date"];
    NSDate *deliveryTime = [[NSDate alloc]init];
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
    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
    [df2 setDateFormat:@"yyyyMMddHHmmss"];
    NSString *todayStr = [df2 stringFromDate:today];
    NSString *deliveryStr = [df2 stringFromDate:deliveryTime];
    NSString *pushID = [todayStr stringByAppendingString:deliveryStr];
    
    // ユーザデフォルトに保存
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
    [push setDeliveryTime:[NSDate dateWithTimeInterval:3*60 sinceDate:deliveryTime]];
    [push setPushToIOS:true];
    //    [push clearExpiration];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             if (succeeded == YES)
             {
                 DLog(@"\n\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", [NSDate dateWithTimeInterval:540*60 sinceDate:alarmDate], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
             }
             else
             {
                 DLog(@"\n\n[ALARM DATE]:%@\n[PUSH SEND]:Miss\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", [NSDate dateWithTimeInterval:540*60 sinceDate:alarmDate], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
             }
         }
         else
         {
             DLog(@"\n\n[ALARM DATE]:%@\n[PUSH SEND]:ERROR\n%@\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", [NSDate dateWithTimeInterval:540*60 sinceDate:alarmDate], error, pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
         }
     }];
    
}


// DatePickerでCancel時の処理
- (IBAction)didCancelButtonClicked:(id)sender
{
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
    
#pragma mark -【GA】キャンセル
    GA_TRACK_EVENT(@"メガネタップ", @"キャンセル", @"", nil);
}


// Alarm ON/OFF切り替え
- (IBAction)AlarmSet
{
    
    // アラーム状態がオフの時は、通知を初期化
    if (alarmEnabled == NO)
    {
        // アラーム編集画面起動
        [self AlarmEdit];
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
        remainLabelFrame.origin.x = 224;
        remainTimeFrame.origin.x = 211;
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


// アラーム通知生成
- (void)AlarmNotification
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
-(void)DTCheck
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // デラオキツイートONの時は状態チェック
    if ([userdefaults boolForKey:@"DT Enabled"])
    {
        DLog(@"\n\n[DT CHECK STARTED]\n\n");
        if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
        {
            // PUSH通知未許可ならDTスイッチOFFでユーザデフォルトに保存 ＆ アラートで告知
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults synchronize];
            NSString *PushSettingTitle = NSLocalizedString(@"PushSettingTitle", nil);
            NSString *PushSettingStr = NSLocalizedString(@"PushSettingStr", nil);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:PushSettingTitle
                                                           message:PushSettingStr
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



//#pragma mark -【DT】アプリ終了時Push通知作成判断
//- (BOOL)DTPushMakeCalc
//{
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    if ([userdefaults boolForKey:@"DT Enabled"] && [userdefaults boolForKey:@"Alarm Enabled"] && ([[userdefaults stringForKey:@"Push ID"] isEqualToString:@""]))
//    {
//        // DT:ON かつ ALARM:ON かつ PUSH IDが空 ならPUSH通知を作成
//        DLog(@"\n\n[DT ENABLE]:%d\n[ALARM ENABLE]:%d\n[PUSH ID]:%@\n[PUSH CALC]:MAKE\n\n", [userdefaults boolForKey:@"DT Enabled"], [userdefaults boolForKey:@"Alarm Enabled"], [userdefaults stringForKey:@"Push ID"]);
//        return YES;
//    }
//    else
//    {
//        DLog(@"\n\n[DT ENABLE]:%d\n[ALARM ENABLE]:%d\n[PUSH ID]:%@\n[PUSH CALC]:NOT MAKE\n\n", [userdefaults boolForKey:@"DT Enabled"], [userdefaults boolForKey:@"Alarm Enabled"], [userdefaults stringForKey:@"Push ID"]);
//        return NO;
//    }
//}


//#pragma mark -【DT】バックグラウンド時のPUSH通知登録タスクの生成
//-(void)PushCreateInBackgroundTask
//{
//    // NSURLセッションの生成
//    NSURL *url = [NSURL URLWithString:@"https://mb.api.cloud.nifty.com/2013-09-01/push"];
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfiguration:@"backgroundTask"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
//    
//    // deliveryTimeの生成
//    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
//    NSDate *deliveryTime = [userdefaults objectForKey:@"Alarm Date"];
//    
//    // Push IDを生成
//    NSDate *today = [NSDate date];
//    NSDateFormatter *df2 = [[NSDateFormatter alloc]init];
//    [df2 setDateFormat:@"yyyyMMddHHmmss"];
//    NSString *todayStr = [df2 stringFromDate:today];
//    NSString *deliveryStr = [df2 stringFromDate:deliveryTime];
//    NSString *pushID = [todayStr stringByAppendingString:deliveryStr];
//    
//    // ユーザデフォルトに保存
//    [userdefaults setValue:pushID forKey:@"Push ID"];
//    [userdefaults synchronize];
//    
//    // dvTokenIDを取得
//    NSString *dvTokenID = [userdefaults stringForKey:@"dvTokenID"];
//    
//    // deliveryTimeをリクエストデータ用の形式に変換"yyyy-mm-ddTHH:MM:ss.SSSZ"
//    NSDateFormatter *df3 = [[NSDateFormatter alloc]init];
//    NSDateFormatter *df4 = [[NSDateFormatter alloc]init];
//    [df3 setDateFormat:@"yyyy-MM-dd"];
//    [df4 setDateFormat:@"HH:mm:ss"];
//    // アラーム時刻の3分後に配信 3*60
//    NSString *deliverydf3 = [df3 stringFromDate:[NSDate dateWithTimeInterval:3*60 sinceDate:deliveryTime]];
//    NSString *deliverydf4 = [df4 stringFromDate:[NSDate dateWithTimeInterval:3*60 sinceDate:deliveryTime]];
//    NSString *deliveryStrJson = [NSString stringWithFormat:@"%@T%@.000Z", deliverydf3, deliverydf4];
//    
//    // JSON形式のリクエストデータを生成
//    NSString *requestJSON = [NSString stringWithFormat:@"{\"deliveryTime\":\"%@\",\"target\":[\"ios\"],\"searchCondition\":{\"deviceToken\":\"%@\"},\"userSettingValue\":{\"pushID\":\"%@\"},\"badgeIncrementFlag\":false,\"contentAvailable\":true}", deliveryStrJson, dvTokenID, pushID];
//    DLog(@"\n\n[REQUEST DATA]:%@\n\n", [NSString stringWithFormat:@"{\n\"deliveryTime\":\"%@\",\n\"target\":[\"ios\"],\n\"searchCondition\":{\"deviceToken\":\"%@\"},\n\"userSettingValue\":{\"pushID\":\"%@\"},\n\"badgeIncrementFlag\":false,\n\"contentAvailable\":true\n}", deliveryStrJson, dvTokenID, pushID]);
//    NSData* data = [requestJSON dataUsingEncoding:NSUTF8StringEncoding];
//    
//    // リクエストの設定　ContentType:application/json, メソッド:POST
//    [request addValue:@"application/json" forHTTPHeaderField:@"ContentType"];
//    request.HTTPMethod = @"POST";
////    request.HTTPBody = data;
//    
//    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request
//                                                         fromData:data
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                                {
//                                                    if (error == nil)
//                                                    {
//                                                        if (data)
//                                                        {
//                                                            NSHTTPURLResponse *httpResopnse = (NSHTTPURLResponse *)response;
//                                                            NSUInteger statusCode = httpResopnse.statusCode;
//                                                            if (statusCode == 201)
//                                                            {
//                                                                // Push通知登録成功時
//                                                                NSError *jsonError;
//                                                                // JSONをパース
//                                                                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
//                                                                DLog(@"\n\n[RESPONSE STATUSCODE]:%d\n[RESPONSE DATA]:%@\n[RESPONSE ERROR]:%@\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]:%@\n\n", statusCode, jsonData, jsonError, [NSDate dateWithTimeInterval:540*60 sinceDate:deliveryTime], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
//                                                            }
//                                                            else
//                                                            {
//                                                                // statusCodeが201以外の時(登録失敗時)
//                                                                NSError *jsonError;
//                                                                // JSONをパース
//                                                                NSArray *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonError];
//                                                                DLog(@"\n\n[RESPONSE STATUSCODE]:%d\n[RESPONSE DATA]:%@\n[RESPONSE ERROR]:%@\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]:%@\n\n", statusCode, jsonData, jsonError, [NSDate dateWithTimeInterval:540*60 sinceDate:deliveryTime], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
//                                                            }
//                                                        }
//                                                        else
//                                                        {
//                                                            // Push通知登録失敗時
//                                                            DLog(@"\n\n[RESPONSE ERROR]:%@\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]:%@\n\n", [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding], [NSDate dateWithTimeInterval:540*60 sinceDate:deliveryTime], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
//                                                        }
//                                                    }
//                                                    else
//                                                    {
//                                                        // リクエスト自体の失敗時
//                                                        DLog(@"\n\n[ERROR]:%@\n[ALARM DATE]:%@\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]:%@\n\n", error, [NSDate dateWithTimeInterval:540*60 sinceDate:deliveryTime], pushID, dvTokenID, [NSDate dateWithTimeInterval:3*60+540*60 sinceDate:deliveryTime]);
//                                                    }
//                                                }];
//    [task resume];
//}


//#pragma mark -【DT】バックグラウンド時のPUSH通知登録タスク実行完了delegateメソッド
//- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
//{
//    DLog(@"Background URL session %@ finished events.\n", session);
//    
//    AlarmAppDelegate *delegate =(AlarmAppDelegate *)[[UIApplication sharedApplication] delegate];
//    if(delegate.backgroundSessionCompletionHandler)
//    {
//        void (^handler)() = delegate.backgroundSessionCompletionHandler;
//        handler();
//    }
//}


- (void)viewWillDisappear:(BOOL)animated
{
    [self.nadView pause]; //広告の定期ロードを中断
    DLog();
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog();
}

- (void)dealloc
{
    [self.nadView setDelegate:nil]; // delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease、nilをセット
    DLog();
}


#pragma mark - 【画面遷移】戻る
- (void)SettingsViewControllerDidFinish:(SettingsViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    DLog();
}

#pragma mark - 【画面遷移】セグエ 識別子とDelegate
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // 識別子をチェックせずに実行する
    [[segue destinationViewController] setDelegate:self];
    
    //    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
    //        [[segue destinationViewController] setDelegate:self];
    //    }
    DLog();
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Debug用メソッド

#pragma mark -【Debug】アラーム停止
- (void)Alarmstop:(UIButton *)sender
{
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
    
    // 広告のロード開始
    [self.nadView resume]; // 広告の定期ロードを再開
    [self.nadView load]; // 広告のロードを開始
    
    
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
    
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error == nil)
         {
             if (succeeded == YES)
             {
                 DLog(@"\n\n[PUSH SEND]:Success\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", pushID, dvTokenID, [NSDate dateWithTimeIntervalSinceNow:1*60+540*60]);
             }
             else
             {
                DLog(@"\n\n[PUSH SEND]:Miss\n\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", pushID, dvTokenID, [NSDate dateWithTimeIntervalSinceNow:1*60+540*60]);
             }
         }
         else
         {
             DLog(@"\n\n[PUSH SEND]:ERROR\n%@\n[PUSH ID]:%@\n[DVTOKEN ID]:%@\n[DELIVERYTIME]: %@\n\n", error, pushID, dvTokenID, [NSDate dateWithTimeIntervalSinceNow:1*60+540*60]);
         }
     }];
}


@end