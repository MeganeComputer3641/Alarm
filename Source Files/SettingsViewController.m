//
//  SettingsViewController.m
//  Alarm
//
//  Created by Megane.computer on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//


#import "SettingsViewController.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import <NCMB/NCMB.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>




@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark -【View】initialize
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        //logoutボタン画像読み込み
        [_ACsettingButton setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
        
        //TweetWords読み込み
        NSString *TWLabel1 = NSLocalizedString(@"TWLabel1", nil);
        NSString *TWLabel2 = NSLocalizedString(@"TWLabel2", nil);
        NSString *TWLabel3 = NSLocalizedString(@"TWLabel3", nil);
        NSString *TWLabel4 = NSLocalizedString(@"TWLabel4", nil);
        NSString *TWLabel5 = NSLocalizedString(@"TWLabel5", nil);
        TWLabelArray = @[TWLabel1, TWLabel2, TWLabel3, TWLabel4, TWLabel5];
        _TWwords1.text = TWLabelArray[0];
        _TWwords2.text = TWLabelArray[1];
        _TWwords3.text = TWLabelArray[2];
        _TWwords4.text = TWLabelArray[3];
        _TWwords5.text = TWLabelArray[4];
        NSString *TWwords1 = NSLocalizedString(@"TWwords1", nil);
        NSString *TWwords2 = NSLocalizedString(@"TWwords2", nil);
        NSString *TWwords3 = NSLocalizedString(@"TWwords3", nil);
        NSString *TWwords4 = NSLocalizedString(@"TWwords4", nil);
        NSString *TWwords5 = NSLocalizedString(@"TWwords5", nil);
        TWwordsArray = @[TWwords1, TWwords2, TWwords3, TWwords4, TWwords5];
        DLog(@"\n\n[TW WORDS]\n1:%@\n2:%@\n3:%@\n4:%@\n5:%@\n\n", TWLabelArray[0], TWLabelArray[1], TWLabelArray[2], TWLabelArray[3], TWLabelArray[4]);
    }
    
    //サウンド名読み込み
    SoundNameArray = @[@"BELL", @"DOG", @"BABY", @"DISCO MODE", @"HARD MODE"];
    DLog(@"\n\n[SOUND NAME]\n1:%@\n2:%@\n3:%@\n4:%@\n5:%@\n\n", SoundNameArray[0], SoundNameArray[1], SoundNameArray[2], SoundNameArray[3], SoundNameArray[4]);
    
#pragma mark -【ad】initialize
    // 広告のサイズ
//    CGFloat y = self.view.frame.size.height + self.view.frame.origin.y - 50.0;
    CGFloat y = self.view.frame.size.height - 50.0;
    CGRect iPhone_3_5inch_banner = CGRectMake(0, y, 320, 50); //3.5inch広告枠サイズ
    CGRect iPhone_4inch_banner = CGRectMake(0, y, 320, 50); //4inch広告枠サイズ
    
    DLog(@"\n\nself.view.frame.size.height: %f\nself.view.frame.origin.y: %f\nCGFloat y: %f\n\n", self.view.frame.size.height, self.view.frame.origin.y, y);
    
    // 3.5inch,4inch両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_3_5inch_banner]; // 広告枠の生成
        DLog(@"\n\n[OS VERSION]: %f\n[nadView.frame]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView.frame.origin.x, self.nadView.frame.origin.y, self.nadView.frame.size.width, self.nadView.frame.size.height);
    }
    else // それ以外の場合、4inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_4inch_banner]; // 広告枠の生成
        
        if(([[UIDevice currentDevice].systemVersion floatValue] < 7.0))
        {
//            // ios6以下なら広告表示位置を調整
//            CGRect nadviewframe = self.nadView.frame;
//            nadviewframe.origin.y = self.nadView.frame.origin.y - 20.0;
//            self.nadView.frame = nadviewframe;
            DLog(@"\n\n[OS VERSION]: %f\n[nadView.frame]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView.frame.origin.x, self.nadView.frame.origin.y, self.nadView.frame.size.width, self.nadView.frame.size.height);
        }
        
        DLog(@"\n\n[OS VERSION]: %f\n[nadView.frame]: (%f, %f, %f, %f)\n\n", [[UIDevice currentDevice].systemVersion floatValue], self.nadView.frame.origin.x, self.nadView.frame.origin.y, self.nadView.frame.size.width, self.nadView.frame.size.height);
    }
    
#pragma mark -【ad】デバッグビルド時の設定
#if DEBUG
    [self.nadView setIsOutputLog:YES]; // 広告Log出力ON
#else
    [self.nadView setIsOutputLog:NO]; // 広告Log出力OFF
#endif
    
    /* 検証用apiKeyとspotId
     サイズ      apiKey                                     spotID
     320 x 50
     320 x100
     300 x100
     300 x250
     728 x 90
     アイコン
     */
    
    // apiKey, spotId.の設定
    [self.nadView setNendID:@"" spotID:@""];
    
    //デリゲートはself
    [self.nadView setDelegate:self];
    
    // 広告のロードを開始
//    [self.nadView load:[NSDictionary dictionaryWithObjectsAndKeys:@"30",@"retry",nil]];
    [self.nadView load];
    
#pragma mark -【GA】設定画面
    self.screenName = @"設定画面";
    GA_TRACK_PAGE(self.screenName);
    
#pragma mark -【GA】ディスパッチ
    // 並列なキュー(global_queue)で非同期(async)、優先度中(DISPATCH_QUEUE_PRIORITY_DEFAULT)
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue,
                   ^{
                       [[GAI sharedInstance] dispatch];
                   });
}



#pragma mark -ユーザ・デフォルトの読み込みと画面同期２
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
#pragma mark -【ad】定期ロード再開
    // 定期ロードを再開
    [self.nadView resume];
    DLog(@"\n\n[NADVIEW SETTINGS]:RESUME\n\n");
    
    
#pragma mark -【画面同期】DTスイッチ・ACラベル・ACボタン同期
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    if(([[UIDevice currentDevice].systemVersion floatValue] >= 7.0))
    {
        if (DTEnabled != [userdefaults boolForKey:@"DT Enabled"])
        {
            DTEnabled = [userdefaults boolForKey:@"DT Enabled"];
        }
        if (ACEnabled != [userdefaults boolForKey:@"AC Enabled"])
        {
            ACEnabled = [userdefaults boolForKey:@"AC Enabled"];
        }
        
        if (DTEnabled == NO || ACEnabled == NO)
        {
            // 3.5inch,4inch両対応
            CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
            if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
            {
                // DT:OFF or AC:DISABLEならDT設定項目を非表示
                [_DTcheckButton setSelected:NO];
                CGRect dtsetviewframe = _DTsetview.frame;
                dtsetviewframe.origin.x = 320;
                _DTsetview.frame = dtsetviewframe;
                _DTsetview.alpha = 0;
                
                // Sound設定項目を上に
                CGRect Soundsetviewframe = _Soundsetview.frame;
                Soundsetviewframe.origin.y = 105;
                _Soundsetview.frame = Soundsetviewframe;
            }
            else // それ以外の場合、4inch
            {
                // DT:OFF or AC:DISABLEならDT設定項目を非表示
                [_DTcheckButton setSelected:NO];
                CGRect dtsetviewframe = _DTsetview.frame;
                dtsetviewframe.origin.x = 320;
                _DTsetview.frame = dtsetviewframe;
                _DTsetview.alpha = 0;
                
                // Sound設定項目を上に
                CGRect Soundsetviewframe = _Soundsetview.frame;
                Soundsetviewframe.origin.y = 110;
                _Soundsetview.frame = Soundsetviewframe;
            }
        }
        else if (DTEnabled == YES && ACEnabled == YES)
        {
            // 3.5inch,4inch両対応
            CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
            if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
            {
                // DT:ON & AC:ENABLEならDT設定項目を表示
                [_DTcheckButton setSelected:YES];
                _AClabel.text = [userdefaults stringForKey:@"TW Username"];
                _AClabel.font = [UIFont fontWithName:@"System" size:12];
                CGRect dtsetviewframe = _DTsetview.frame;
                dtsetviewframe.origin.x = 33;
                _DTsetview.frame = dtsetviewframe;
                _DTsetview.alpha = 1;
                
                // Sound設定項目を下に
                CGRect Soundsetviewframe = _Soundsetview.frame;
                Soundsetviewframe.origin.y = 275;
                _Soundsetview.frame = Soundsetviewframe;
            }
            else // それ以外の場合、4inch
            {
                // DT:ON & AC:ENABLEならDT設定項目を表示
                [_DTcheckButton setSelected:YES];
                _AClabel.text = [userdefaults stringForKey:@"TW Username"];
                _AClabel.font = [UIFont fontWithName:@"System" size:12];
                CGRect dtsetviewframe = _DTsetview.frame;
                dtsetviewframe.origin.x = 33;
                _DTsetview.frame = dtsetviewframe;
                _DTsetview.alpha = 1;
                
                // Sound設定項目を下に
                CGRect Soundsetviewframe = _Soundsetview.frame;
                Soundsetviewframe.origin.y = 320;
                _Soundsetview.frame = Soundsetviewframe;
            }
        }
        
#pragma mark -【画面同期】TweetWords同期
        //最初に全OFF
        [_TWcheckbox1 setSelected:NO];
        [_TWcheckbox2 setSelected:NO];
        [_TWcheckbox3 setSelected:NO];
        [_TWcheckbox4 setSelected:NO];
        [_TWcheckbox5 setSelected:NO];
        
        //ユーザデフォルトから選択中のWordsを同期
        switch ([userdefaults integerForKey:@"TW Words Number"])
        {
            case 1:
                [_TWcheckbox1 setSelected:YES];
                break;
            case 2:
                [_TWcheckbox2 setSelected:YES];
                break;
            case 3:
                [_TWcheckbox3 setSelected:YES];
                break;
            case 4:
                [_TWcheckbox4 setSelected:YES];
                break;
            case 5:
                [_TWcheckbox5 setSelected:YES];
                break;
        }
    }
    else
    {
        // 3.5inch,4inch両対応
        CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
        if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
        {
            // osのバージョンが7.0以下ならDT設定項目を非表示
            [_DTcheckButton setSelected:NO];
            CGRect dtviewframe = _DTview.frame;
            CGRect dtsetviewframe = _DTsetview.frame;
            dtviewframe.origin.x = 320;
            dtsetviewframe.origin.x = 320;
            _DTview.frame = dtviewframe;
            _DTsetview.frame = dtsetviewframe;
            _DTsetview.alpha = 0;
            
            // Sound設定項目を上に
            CGRect Soundsetviewframe = _Soundsetview.frame;
            Soundsetviewframe.origin.y = 90;
            _Soundsetview.frame = Soundsetviewframe;
        }
        else // それ以外の場合、4inch
        {
            // osのバージョンが7.0以下ならDT設定項目を非表示
            [_DTcheckButton setSelected:NO];
            CGRect dtviewframe = _DTview.frame;
            CGRect dtsetviewframe = _DTsetview.frame;
            dtviewframe.origin.x = 320;
            dtsetviewframe.origin.x = 320;
            _DTview.frame = dtviewframe;
            _DTsetview.frame = dtsetviewframe;
            _DTsetview.alpha = 0;
            
            // Sound設定項目を上に
            CGRect Soundsetviewframe = _Soundsetview.frame;
            Soundsetviewframe.origin.y = 95;
            _Soundsetview.frame = Soundsetviewframe;
        }
        
    }
#pragma mark -【画面同期】Sound同期
    //最初に全OFF
    [_Scheckbox1 setSelected:NO];
    [_Scheckbox2 setSelected:NO];
    [_Scheckbox3 setSelected:NO];
    [_Scheckbox4 setSelected:NO];
    [_Scheckbox5 setSelected:NO];
    
    //ユーザデフォルトから選択中のWordsを同期
    switch ([userdefaults integerForKey:@"Sound Number"])
    {
        case 1:
            [_Scheckbox1 setSelected:YES];
            break;
        case 2:
            [_Scheckbox2 setSelected:YES];
            break;
        case 3:
            [_Scheckbox3 setSelected:YES];
            break;
        case 4:
            [_Scheckbox4 setSelected:YES];
            break;
        case 5:
            [_Scheckbox5 setSelected:YES];
            break;
    }
    DLog(@"\n\n[TW WORDS NUMBER]:%ld\n[TW WORDS]:%@\n\n\n[SOUND NUMBER]:%ld\n[SOUND NAME]:%@\n\n",(long)[userdefaults integerForKey:@"TW Words Number"], [userdefaults stringForKey:@"TW Words"], (long)[userdefaults integerForKey:@"Sound Number"], [userdefaults stringForKey:@"Sound Name"]);
    
}

#pragma mark -【ad】初回ロード成功
- (void)nadViewDidFinishLoad:(NADView *)adView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DLog(@"\n\n[NAD VIEW SETTINGS]:初回ロード\n\n");
    
    //広告を表示
    [self.view addSubview:self.nadView];
    [userDefaults setBool:YES forKey:@"AD VIEW SETTINGS"];
    [userDefaults synchronize];
    
    DLog(@"\n\n[広告枠]:表示\n[AD VIEW SETTINGS]:%d\n\n", [userDefaults boolForKey:@"AD VIEW SETTINGS"]);
}


#pragma mark -【ad】ロード成功(初回以降)
- (void)nadViewDidReceiveAd:(NADView *)adView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DLog(@"\n\n[NAD VIEW SETTINGS]:定期ロード\n\n");
    
    if (![userDefaults boolForKey:@"AD VIEW SETTINGS"])
    {
        // 広告が表示されていない場合は、表示
        [self.view addSubview:self.nadView];
        [userDefaults setBool:YES forKey:@"AD VIEW SETTINGS"];
        [userDefaults synchronize];
        
        DLog(@"\n\n[広告枠]:表示\n[AD VIEW SETTINGS]:%d\n\n", [userDefaults boolForKey:@"AD VIEW SETTINGS"]);
    }
}


#pragma mark -【ad】ロード失敗
- (void)nadViewDidFailToReceiveAd:(NADView *)adView
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    DLog(@"\n\n[NAD VIEW SETTINGS]:受信エラー\n\n");
    
    // 広告を削除
    [self.nadView removeFromSuperview];
    [userDefaults setBool:NO forKey:@"AD VIEW SETTINGS"];
    [userDefaults synchronize];
    
    DLog(@"\n\n[広告枠]:削除\n[AD VIEW SETTINGS]:%d\n\n", [userDefaults boolForKey:@"AD VIEW SETTINGS"]);
}


// 画面遷移で戻る時の処理
- (void)viewWillDisappear:(BOOL)animated
{
    DLog();
    [super viewWillDisappear:animated];
    
    //広告の定期ロードを中断
    [self.nadView pause];
    DLog(@"\n\n[NADVIEW SETTINGS]:PAUSE\n\n");

}


#pragma mark -【画面遷移】Swipeで戻る
- (IBAction)Back:(id)sender
{
    [self.delegate SettingsViewControllerDidFinish:self];
}

#pragma mark -logoutボタンクリック時の処理
- (IBAction)ACButtonClicked
{
    // DT:OFF,AC:DISABLEでユーザフォルトに保存
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setBool:NO forKey:@"AC Enabled"];
    [userdefaults setBool:NO forKey:@"DT Enabled"];
    [userdefaults synchronize];
    
    // 3.5inch,4inch両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        // DT設定項目を非表示に
        CGRect dtsetviewframe = _DTsetview.frame;
        dtsetviewframe.origin.x = 320;
        _DTsetview.frame = dtsetviewframe;
        _DTsetview.alpha = 0;
        
        [_DTcheckButton setSelected:NO];
        
        // Sound設定項目を上に
        CGRect Soundsetviewframe = _Soundsetview.frame;
        Soundsetviewframe.origin.y = 105;
        [UIView animateWithDuration:0.4
                         animations:^{
                             _Soundsetview.frame = Soundsetviewframe;
                         }];
    }
    else // それ以外の場合、4inch
    {
        // DT設定項目を非表示に
        CGRect dtsetviewframe = _DTsetview.frame;
        dtsetviewframe.origin.x = 320;
        _DTsetview.frame = dtsetviewframe;
        _DTsetview.alpha = 0;
        
        [_DTcheckButton setSelected:NO];
        
        // Sound設定項目を上に
        CGRect Soundsetviewframe = _Soundsetview.frame;
        Soundsetviewframe.origin.y = 110;
        [UIView animateWithDuration:0.4
                         animations:^{
                             _Soundsetview.frame = Soundsetviewframe;
                         }];
    }
    
    DLog(@"\n\n[DT]:OFF\n[ACCOUNT STATUS]:DISABLE\n\n");
}

#pragma mark -DTチェックボックスクリック時の処理
- (IBAction)DTButtonClicked
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults boolForKey:@"DT Enabled"])
    {
        // DT:ONの時は、DT:OFF
        DTEnabled = NO;
        [userdefaults setBool:NO forKey:@"DT Enabled"];
        
        // PushIDを初期化
        [userdefaults setValue:@"" forKey:@"Push ID"];
        
        [userdefaults synchronize];
        
        // 3.5inch,4inch両対応
        CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
        if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
        {
            // DT設定項目を非表示に
            CGRect dtsetviewframe = _DTsetview.frame;
            dtsetviewframe.origin.x = 320;
            _DTsetview.frame = dtsetviewframe;
            _DTsetview.alpha = 0;
            
            [_DTcheckButton setSelected:NO];
            
            // Sound設定項目を上に
            CGRect Soundsetviewframe = _Soundsetview.frame;
            Soundsetviewframe.origin.y = 105;
            [UIView animateWithDuration:0.4
                             animations:^{
                                 _Soundsetview.frame = Soundsetviewframe;
                             }];
        }
        else // それ以外の場合、4inch
        {
            // DT設定項目を非表示に
            CGRect dtsetviewframe = _DTsetview.frame;
            dtsetviewframe.origin.x = 320;
            _DTsetview.frame = dtsetviewframe;
            _DTsetview.alpha = 0;
            
            [_DTcheckButton setSelected:NO];
            
            // Sound設定項目を上に
            CGRect Soundsetviewframe = _Soundsetview.frame;
            Soundsetviewframe.origin.y = 110;
            [UIView animateWithDuration:0.4
                             animations:^{
                                 _Soundsetview.frame = Soundsetviewframe;
                             }];
        }
        
        DLog(@"\n\n[DT]:OFF\n\n");
    }
    else
    {
        if ([userdefaults boolForKey:@"DT Useflag"] == NO)
        {
            // 初回Push通知確認
            // Push通知を許可するよう事前にアラートで告知
            NSString *NotifStartTitle;
            NSString *NotifStartStr;
            
            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
                NotifStartTitle = NSLocalizedString(@"NotifStartTitle_iOS8", nil);
                NotifStartStr = NSLocalizedString(@"NotifStartStr_iOS8", nil);
            }else{
                NotifStartTitle = NSLocalizedString(@"PushStartTitle", nil);
                NotifStartStr = NSLocalizedString(@"PushStartStr", nil);
            }
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NotifStartTitle
                                                           message:NotifStartStr
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:@"OK", nil];
            [alert show];
            [_DTcheckButton setSelected:NO];
            
            DTEnabled = NO;
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults synchronize];
            DLog(@"\n\n[DT FIRSTFLAG]:%d\n[DVTOKEN ID]:%@\n[DT]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"], [userdefaults stringForKey:@"dvTokenID"], [userdefaults boolForKey:@"DT Enabled"]);
        }
        else
        {
            if ([[userdefaults stringForKey:@"dvTokenID"] length] == 0)
            {
                // dvTokenID未取得時はアラートで告知
                DTEnabled = NO;
                [userdefaults setBool:NO forKey:@"DT Enabled"];
                [userdefaults synchronize];
                // Push通知設定確認後、再起動するようアラートで告知
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
                [_DTcheckButton setSelected:NO];
                DLog(@"\n\n[DT FIRSTFLAG]:%d\n[DVTOKEN ID]:%@\n[DT]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"], [userdefaults stringForKey:@"dvTokenID"], [userdefaults boolForKey:@"DT Enabled"]);
            }
            else
            {
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
                    // PUSH通知未許可ならDTスイッチOFF ＆ アラートで告知
                    DTEnabled = NO;
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
                    [_DTcheckButton setSelected:NO];
                    DLog(@"\n\n[DT FIRSTFLAG]:%d\n[DVTOKEN ID]:%@\n[PUSH STATUS]:DISABLE\n[DT]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"], [userdefaults stringForKey:@"dvTokenID"], [userdefaults boolForKey:@"DT Enabled"]);
                }
                else
                {
                    // アカウント状態チェック
                    DLog(@"\n\n-CHECK OK-\n[DT FIRSTFLAG]:%d\n[DVTOKEN ID]:%@\n[PUSH STATUS]:ENABLE\n[DT]:%d\n\n", [userdefaults boolForKey:@"DT Useflag"], [userdefaults stringForKey:@"dvTokenID"], [userdefaults boolForKey:@"DT Enabled"]);
                    [self TweetAccount];
                }
            }
        }
    }
}

#pragma mark -【DT】DTInfo表示
- (IBAction)DTInfoClicked
{
    DLog();
    //アラートでDT解説を表示
    NSString *DTinfoTitle = NSLocalizedString(@"DTinfoTitle", nil);
    NSString *DTinfoStr = NSLocalizedString(@"DTinfolabel", nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DTinfoTitle
                                                   message:DTinfoStr
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Close", nil];
    [alert show];
    
}

#pragma mark -【DT】ツイートワーズ処理
- (void)TweetWordsSelect:(int)number
{
    //最初に全OFF
    [_TWcheckbox1 setSelected:NO];
    [_TWcheckbox2 setSelected:NO];
    [_TWcheckbox3 setSelected:NO];
    [_TWcheckbox4 setSelected:NO];
    [_TWcheckbox5 setSelected:NO];
    
    //ユーザデフォルトに保存
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:TWwordsArray[number] forKey:@"TW Words"];
    [userdefaults setInteger:number + 1 forKey:@"TW Words Number"];
    [userdefaults synchronize];
    
    //Checkbox同期
    switch ([userdefaults integerForKey:@"TW Words Number"])
    {
        case 1:
            [_TWcheckbox1 setSelected:YES];
            break;
        case 2:
            [_TWcheckbox2 setSelected:YES];
            break;
        case 3:
            [_TWcheckbox3 setSelected:YES];
            break;
        case 4:
            [_TWcheckbox4 setSelected:YES];
            break;
        case 5:
            [_TWcheckbox5 setSelected:YES];
            break;
    }
    DLog(@"\n\n[TW CHECK BOX]:%d CLICKED\n[TW WORDS NUMBER]:%ld\n[TW WORDS]:%@\n\n", number+1,(long)[userdefaults integerForKey:@"TW Words Number"], [userdefaults stringForKey:@"TW Words"]);
}

#pragma mark -【DT】TWボタン1クリッック
- (IBAction)TWcheckbox1Clicked
{
    [self TweetWordsSelect:0];
}

#pragma mark -【DT】TWボタン2クリッック
- (IBAction)TWcheckbox2Clicked
{
    [self TweetWordsSelect:1];
}

#pragma mark -【DT】TWボタン3クリッック
- (IBAction)TWcheckbox3Clicked
{
    [self TweetWordsSelect:2];
}

#pragma mark -【DT】TWボタン4クリッック
- (IBAction)TWcheckbox4Clicked
{
    [self TweetWordsSelect:3];
}

#pragma mark -【DT】TWボタン5クリッック
- (IBAction)TWcheckbox5Clicked
{
    [self TweetWordsSelect:4];
}


#pragma mark -【DT】AAInfoボタン4クリッック
- (IBAction)TW4InfoClicked
{
    //アラートでAAを表示
    //    NSString *AATitle = NSLocalizedString(@"TWLabel4", nil);
    NSString *AAStr = NSLocalizedString(@"AAInfo4", nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:AAStr
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Close", nil];
    [alert show];
}


#pragma mark -【DT】AAInfoボタン5クリッック
- (IBAction)TW5InfoClicked
{
    //アラートでAAを表示
    //    NSString *AATitle = NSLocalizedString(@"TWLabel5", nil);
    NSString *AAStr = NSLocalizedString(@"AAInfo5", nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:AAStr
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Close", nil];
    [alert show];
}


#pragma mark -【DT】DT初回確認時dvTokenID取得
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    DLog(@"\n\n[BUTTON INDEX]:%ld\n\n", (long)buttonIndex);
    DLog(@"\n\n[OS VERSION]:%@\n[DVTOKEN ID]:%@\n\n", [[UIDevice currentDevice] systemVersion], [[NSUserDefaults standardUserDefaults] stringForKey:@"dvTokenID"]);
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1){
        if (buttonIndex == 1) {
            
            /* iOS8以上でのdvtokenID取得 */
            DLog(@"\n[OS VERSION]: iOS 8以上\n\n");
            UIUserNotificationType type = UIUserNotificationTypeAlert |
                                          UIUserNotificationTypeBadge |
                                          UIUserNotificationTypeSound;
            UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:type
                                                                                    categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
            [[UIApplication sharedApplication] registerForRemoteNotifications];
            
            }
    }else{
        if (buttonIndex == 0){
            /* iOS7でのdvtokenID取得 */
            DLog(@"\n[OS VERSION]: iOS 7以下\n\n");
            [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
             (UIRemoteNotificationTypeAlert |
              UIRemoteNotificationTypeBadge |
              UIRemoteNotificationTypeSound)]; }
    }
    
    // DT初回確認フラグ解除
    [userdefaults setBool:YES forKey:@"DT Useflag"];
    [userdefaults synchronize];
}


#pragma mark -【Debug】Twitterアカウント取得
- (void)TweetAccount
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    // アカウント設定開始
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [accountStore requestAccessToAccountsWithType:twAccountType
                                          options:NULL
                                       completion:^(BOOL granted, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if (granted)
                            {
                                NSArray* accounts = [accountStore accountsWithAccountType:twAccountType];
                                if([accounts count] == 0)
                                {
                                    //Twitterアカウント設定が１つもない場合の処理
                                    ACEnabled = NO;
                                    DTEnabled = NO;
                                    [userDefaults setBool:NO forKey:@"AC Enabled"];
                                    [userDefaults setBool:NO forKey:@"DT Enabled"];
                                    [userDefaults synchronize];
                                    
                                    //Accountを登録するようアラートで告知
                                    NSString *twSettingTitle = NSLocalizedString(@"twSettingTitle", nil);
                                    NSString *twSettingStr = NSLocalizedString(@"twSettingStr", nil);
                                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:twSettingTitle
                                                                                   message:twSettingStr
                                                                                  delegate:nil
                                                                         cancelButtonTitle:nil
                                                                         otherButtonTitles:@"OK", nil];
                                    [alert show];
                                    [_DTcheckButton setSelected:NO];
                                    DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:OK\n[PUSH STATUS]:ENABLE\n[ACCOUNT STATUS]:DISABLE\n[TW ACCOUNT]:NONE\n\n[DT]:OFF\n\n");
                                }
                                else if([accounts count] > 1)
                                {
                                    // 複数アカウントの場合
                                    NSString *multiAccountTitle = NSLocalizedString(@"multiAccountTitle", nil);
                                    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:multiAccountTitle cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:nil];
                                    
                                    // アカウントの数ぶんアクションシートのボタンを増やす
                                    for (NSInteger i=0; i<[accounts count]; i++)
                                    {
                                        RIButtonItem* button = [RIButtonItem itemWithLabel:[NSString stringWithFormat:@"%@", [[accounts objectAtIndex:i] accountDescription]]];
                                        [button setAction:^(void)
                                         {
                                             // ユーザ・デフォルトにアカウントのindex番号を保存
                                             NSString *userName = [NSString stringWithFormat:@"@%@", [[accounts objectAtIndex:i] valueForKey:@"username"]];
                                             ACEnabled = YES;
                                             [userDefaults setInteger:i forKey:@"Account Index"];
                                             [userDefaults setValue:userName forKey:@"TW Username"];
                                             [userDefaults setBool:YES forKey:@"AC Enabled"];
                                             
                                             // UI同期
                                             _AClabel.text = [userDefaults stringForKey:@"TW Username"];
                                             _AClabel.font = [UIFont fontWithName:@"System" size:12];
                                             
                                             // アカウント登録/許可 済みならDT:ONに
                                             DTEnabled = YES;
                                             [userDefaults setBool:YES forKey:@"DT Enabled"];
                                             [userDefaults synchronize];
                                             [_DTcheckButton setSelected:YES];
                                             
                                             // 3.5inch,4inch両対応
                                             CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
                                             if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
                                             {
                                                 // DT設定項目を表示
                                                 _DTsetview.alpha = 1;
                                                 CGRect dtsetviewframe = _DTsetview.frame;
                                                 dtsetviewframe.origin.x = 33;
                                                 [UIView animateWithDuration:0.4
                                                                  animations:^{
                                                                      _DTsetview.frame = dtsetviewframe;
                                                                  }];
                                                 
                                                 // Sound設定項目を下に
                                                 CGRect Soundsetviewframe = _Soundsetview.frame;
                                                 Soundsetviewframe.origin.y = 275;
                                                 [UIView animateWithDuration:0.4
                                                                  animations:^{
                                                                      _Soundsetview.frame = Soundsetviewframe;
                                                                  }];
                                             }
                                             else // それ以外の場合、4inch
                                             {
                                                 // DT設定項目を表示
                                                 _DTsetview.alpha = 1;
                                                 CGRect dtsetviewframe = _DTsetview.frame;
                                                 dtsetviewframe.origin.x = 33;
                                                 [UIView animateWithDuration:0.4
                                                                  animations:^{
                                                                      _DTsetview.frame = dtsetviewframe;
                                                                  }];
                                                 
                                                 // Sound設定項目を下に
                                                 CGRect Soundsetviewframe = _Soundsetview.frame;
                                                 Soundsetviewframe.origin.y = 320;
                                                 [UIView animateWithDuration:0.4
                                                                  animations:^{
                                                                      _Soundsetview.frame = Soundsetviewframe;
                                                                  }];
                                             }
                                             
                                             // Push通知作成判断
                                             [self DTPushMakeCalc];
                                             
                                             DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:OK\n[PUSH STATUS]:ENABLE\n[TW ACCOUNT]:MULTI\n[ACCOUNT NAME]:%@\n[ACCOUNT STATUS]:ENABLE\n\n[DT]:ON\n\n", [userDefaults stringForKey:@"TW Username"]);
                                         }];
                                        [sheet addButtonItem:button];
                                    }
                                    [sheet addButtonItem:[RIButtonItem itemWithLabel:@"Cancel"]];
                                    [sheet setCancelButtonIndex:[accounts count]];
                                    [sheet showInView:self.view];

                                }
                                else
                                {
                                    //Twitterアカウントが１つだけの場合
                                    // ユーザ・デフォルトにアカウントのindex番号を保存
                                    NSString *userName = [NSString stringWithFormat:@"@%@", [[accounts objectAtIndex:0] valueForKey:@"username"]];
                                    ACEnabled = YES;
                                    [userDefaults setInteger:0 forKey:@"Account Index"];
                                    [userDefaults setValue:userName forKey:@"TW Username"];
                                    [userDefaults setBool:YES forKey:@"AC Enabled"];
                                    
                                    // UI同期
                                    _AClabel.text = [userDefaults stringForKey:@"TW Username"];
                                    _AClabel.font = [UIFont fontWithName:@"System" size:12];
                                    
                                    // アカウント登録/許可 済みならDT:ONに
                                    DTEnabled = YES;
                                    [userDefaults setBool:YES forKey:@"DT Enabled"];
                                    [userDefaults synchronize];
                                    [_DTcheckButton setSelected:YES];
                                    
                                    // 3.5inch,4inch両対応
                                    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
                                    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
                                    {
                                        // DT設定項目を表示
                                        _DTsetview.alpha = 1;
                                        CGRect dtsetviewframe = _DTsetview.frame;
                                        dtsetviewframe.origin.x = 33;
                                        [UIView animateWithDuration:0.4
                                                         animations:^{
                                                             _DTsetview.frame = dtsetviewframe;
                                                         }];
                                        
                                        // Sound設定項目を下に
                                        CGRect Soundsetviewframe = _Soundsetview.frame;
                                        Soundsetviewframe.origin.y = 275;
                                        [UIView animateWithDuration:0.4
                                                         animations:^{
                                                             _Soundsetview.frame = Soundsetviewframe;
                                                         }];
                                    }
                                    else // それ以外の場合、4inch
                                    {
                                        // DT設定項目を表示
                                        _DTsetview.alpha = 1;
                                        CGRect dtsetviewframe = _DTsetview.frame;
                                        dtsetviewframe.origin.x = 33;
                                        [UIView animateWithDuration:0.4
                                                         animations:^{
                                                             _DTsetview.frame = dtsetviewframe;
                                                         }];
                                        
                                        // Sound設定項目を下に
                                        CGRect Soundsetviewframe = _Soundsetview.frame;
                                        Soundsetviewframe.origin.y = 320;
                                        [UIView animateWithDuration:0.4
                                                         animations:^{
                                                             _Soundsetview.frame = Soundsetviewframe;
                                                         }];
                                    }
                                    
                                    // Push通知作成判断
                                    [self DTPushMakeCalc];
                                    
                                    DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:OK\n[PUSH STATUS]:ENABLE\n[TW ACCOUNT]:ONE\n[ACCOUNT NAME]:%@\n[ACCOUNT STATUS]:ENABLE\n\n[DT]:ON\n\n", [userDefaults stringForKey:@"TW Username"]);
                                }
                            }
                            else
                            {
                                //データが取得できない場合
                                ACEnabled = NO;
                                DTEnabled = NO;
                                [userDefaults setBool:NO forKey:@"AC Enabled"];
                                [userDefaults setBool:NO forKey:@"DT Enabled"];
                                [userDefaults synchronize];
                                
                                
                                //Accountの使用を許可するようアラートで告知
                                NSString *twSettingErrorTitle = NSLocalizedString(@"twSettingErrorTitleStr", nil);
                                NSString *twSettingErrorStr = NSLocalizedString(@"twSettingErrorStr", nil);
                                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:twSettingErrorTitle
                                                                               message:twSettingErrorStr
                                                                              delegate:nil
                                                                     cancelButtonTitle:nil
                                                                     otherButtonTitles:@"OK", nil];
                                [alert show];
                                [_DTcheckButton setSelected:NO];
                                DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:OK\n[PUSH STATUS]:ENABLE\n\n[TW ACCOUNT]:ERROR%@\n[ACCOUNT STATUS]:DISABLE\n\n[DT]:OFF\n\n", error);
                            }
                        });
     }];
}



#pragma mark -【Sound】サウンド選択処理
- (void)SoundSelect:(int)number
{
    //最初に全OFF
    [_Scheckbox1 setSelected:NO];
    [_Scheckbox2 setSelected:NO];
    [_Scheckbox3 setSelected:NO];
    [_Scheckbox4 setSelected:NO];
    [_Scheckbox5 setSelected:NO];
    
    //ユーザデフォルトに保存
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    [userdefaults setObject:SoundNameArray[number] forKey:@"Sound Name"];
    [userdefaults setInteger:number + 1 forKey:@"Sound Number"];
    //試聴フラグON
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:5];
    [userdefaults setBool:YES forKey:@"Sound Test"];
    [userdefaults setObject:today forKey:@"Test Date"];
    
    [userdefaults synchronize];
    
    //Checkbox同期
    switch ([userdefaults integerForKey:@"Sound Number"])
    {
        case 1:
            [_Scheckbox1 setSelected:YES];
            break;
        case 2:
            [_Scheckbox2 setSelected:YES];
            break;
        case 3:
            [_Scheckbox3 setSelected:YES];
            break;
        case 4:
            [_Scheckbox4 setSelected:YES];
            break;
        case 5:
            [_Scheckbox5 setSelected:YES];
            break;
    }
    DLog(@"\n\n[SOUND CHECK BOX]:%d CLICKED\n[SOUND NUMBER]:%ld\n[SOUND NAME]:%@\n[END DATE]:%@\n", number + 1,(long)[userdefaults integerForKey:@"Sound Number"], [userdefaults stringForKey:@"Sound Name"], [NSDate dateWithTimeInterval:60*540 sinceDate:[userdefaults objectForKey:@"Test Date"]]);
    
}


#pragma mark -【Sound】Sボタン1クリッック
- (IBAction)Scheckbox1Clicked
{
    [self SoundSelect:0];
}

#pragma mark -【Sound】Sボタン2クリッック
- (IBAction)Scheckbox2Clicked
{
    [self SoundSelect:1];
}

#pragma mark -【Sound】Sボタン3クリッック
- (IBAction)Scheckbox3Clicked
{
    [self SoundSelect:2];
}

#pragma mark -【Sound】Sボタン4クリッック
- (IBAction)Scheckbox4Clicked
{
    [self SoundSelect:3];
}

#pragma mark -【Sound】Sボタン5クリッック
- (IBAction)Scheckbox5Clicked
{
    [self SoundSelect:4];
}


#pragma mark -【DT】DT:ON時Push通知作成判断
- (void)DTPushMakeCalc
{
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    if ([userdefaults boolForKey:@"DT Enabled"] && [userdefaults boolForKey:@"Alarm Enabled"] && ([[userdefaults stringForKey:@"Push ID"] isEqualToString:@""]))
    {
        // DT:ON かつ ALARM:ON かつ PUSH IDが空 ならPUSH通知を作成
        DLog(@"\n\n[DT ENABLE]:%d\n[ALARM ENABLE]:%d\n[PUSH ID]:%@\n[PUSH CALC]:MAKE\n\n", [userdefaults boolForKey:@"DT Enabled"], [userdefaults boolForKey:@"Alarm Enabled"], [userdefaults stringForKey:@"Push ID"]);
        [self.delegate dtPushMake];
    }
    else
    {
        // DT:ON かつ ALARM:ON かつ PUSH IDが空　じゃないならスルー
        DLog(@"\n\n[DT ENABLE]:%d\n[ALARM ENABLE]:%d\n[PUSH ID]:%@\n[PUSH CALC]:NOT MAKE\n\n", [userdefaults boolForKey:@"DT Enabled"], [userdefaults boolForKey:@"Alarm Enabled"], [userdefaults stringForKey:@"Push ID"]);
    }
}



- (void)didReceiveMemoryWarning
{
    DLog();
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)dealloc
{
    [self.nadView setDelegate:nil]; // delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease、nilをセット
    DLog(@"\n\n[self.nadView.delegate]:%@\n[self.nadView]:%@\n\n", self.nadView.delegate, self.nadView);
}


@end
