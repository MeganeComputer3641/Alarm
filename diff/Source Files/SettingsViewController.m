//
//  SettingsViewController.m
//  Test_SettingsviewController
//
//  Created by Megane.computer on 2014/03/21.
//  Copyright (c) 2014年 Meganecomputer. All rights reserved.
//

#import "SettingsViewController.h"
#import "RIButtonItem.h"
#import "UIActionSheet+Blocks.h"
#import "CheckboxButton.h"


@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
#pragma mark -広告表示設定
    // 広告のサイズ
    CGFloat y = self.view.frame.size.height + self.view.frame.origin.y - 50.0;
    CGRect iPhone_3_5inch_banner = CGRectMake(0, y, 320, 50); //3.5inch広告枠サイズ
    CGRect iPhone_4inch_banner = CGRectMake(0, y, 320, 50); //4inch広告枠サイズ

    // 3.5inch,4inch両対応
    CGRect window = [[UIScreen mainScreen] bounds]; // Windowスクリーンのサイズを取得
    if(window.size.height == 480) // 縦の長さが480の場合、3.5inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_3_5inch_banner]; // 広告枠の生成
    }
    else // それ以外の場合、4inch
    {
        self.nadView = [[NADView alloc] initWithFrame:iPhone_4inch_banner]; // 広告枠の生成
    }
    
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
    [self.nadView setNendID:@"c234cbcbfd0ff73340acc1c29e99be3f930c005f"
                     spotID:@"128847"];
    
    //デリゲートはself
    [self.nadView setDelegate:self];
    
#pragma mark -デバッグビルド時の設定
#if DEBUG
    [self.nadView setIsOutputLog:YES]; // 広告Log出力ON
#else
    [self.nadView setIsOutputLog:NO]; // 広告Log出力OFF
#endif
    
    //広告のロードを開始
    [self.nadView load];
    
    
#pragma mark -【GA】ホーム画面
    self.screenName = @"設定画面";
    GA_TRACK_PAGE(self.screenName);
}



#pragma mark -ユーザ・デフォルトの読み込みと画面同期２
- (void)viewWillAppear:(BOOL)animated
{
    
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
    DLog(@"\n\n[TW WORDS NUMBER]:%d\n[TW WORDS]:%@\n\n\n[SOUND NUMBER]:%d\n[SOUND NAME]:%@\n\n",[userdefaults integerForKey:@"TW Words Number"], [userdefaults stringForKey:@"TW Words"], [userdefaults integerForKey:@"Sound Number"], [userdefaults stringForKey:@"Sound Name"]);
    
    [self.nadView resume]; // 定期ロードを再開
}

// 広告受信成功時の処理
- (void)nadViewDidReceiveAd:(NADView *)adView
{
    if (![self.nadView isDescendantOfView:self.view])
    {
        // 広告が表示されていない場合は広告viewを追加
        [self.view addSubview:self.nadView];
        DLog();
    }
}


// 広告受信失敗時の処理
- (void)nadViewDidFailToReceiveAd:(NADView *)adView;
{
    if ([self.nadView isDescendantOfView:self.view])
    {
        // 広告が表示されていた場合は広告viewを削除
        [self.nadView removeFromSuperview];
        DLog();
    }
}


// 画面遷移で戻る時の処理
- (void)viewWillDisappear:(BOOL)animated
{
    [self.nadView pause]; //広告の定期ロードを中断
    DLog();
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
            DLog(@"\n\n[DT FIRSTFLAG]:YET\n\n[DT]:OFF\n\n");
            // 初回Push通知確認
            // Push通知を許可するよう事前にアラートで告知
            NSString *PushStartTitle = NSLocalizedString(@"PushStartTitle", nil);
            NSString *PushStartStr = NSLocalizedString(@"PushStartStr", nil);
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:PushStartTitle
                                                           message:PushStartStr
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"OK", nil];
            [alert show];
            [_DTcheckButton setSelected:NO];
            
            // DT初回確認フラグ解除
            DTEnabled = NO;
            [userdefaults setBool:NO forKey:@"DT Enabled"];
            [userdefaults setBool:YES forKey:@"DT Useflag"];
            [userdefaults synchronize];
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
                NSString *dvTokenSetTitle = NSLocalizedString(@"PushSettingTitle", nil);
                NSString *dvTokenSetStr = NSLocalizedString(@"dvTokenSetStr", nil);
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:dvTokenSetTitle
                                                               message:dvTokenSetStr
                                                              delegate:nil
                                                     cancelButtonTitle:nil
                                                     otherButtonTitles:@"OK", nil];
                [alert show];
                [_DTcheckButton setSelected:NO];
                DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:NONE\n\n[DT]:OFF\n\n");
            }
            else
            {
                if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone)
                {
                    // PUSH通知未許可ならDTスイッチOFF ＆ アラートで告知
                    DTEnabled = NO;
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
                    [_DTcheckButton setSelected:NO];
                    DLog(@"\n\n[DT FIRSTFLAG]:DONE\n[DVTOKEN ID]:OK\n[PUSH STATUS]:DISABLE\n\n[DT]:OFF\n\n");
                }
                else
                {
                    // アカウント状態チェック
                    [self TweetAccount];
                }
            }
        }
    }
}

#pragma mark -【DT】DTInfo表示
- (IBAction)DTInfoClicked
{
    //アラートでDT解説を表示
    NSString *DTinfoTitle = NSLocalizedString(@"DTinfoTitle", nil);
    NSString *DTinfoStr = NSLocalizedString(@"DTinfolabel", nil);
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:DTinfoTitle
                                                   message:DTinfoStr
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"Close", nil];
    [alert show];
    DLog();
}

#pragma mark -【DT】ツイートワーズ処理
- (void)TweetWordsSelect:(NSInteger)number
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
    DLog(@"\n\n[TW CHECK BOX]:%d CLICKED\n[TW WORDS NUMBER]:%d\n[TW WORDS]:%@\n\n", number + 1,[userdefaults integerForKey:@"TW Words Number"], [userdefaults stringForKey:@"TW Words"]);
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
    DLog(@"\n\n[BUTTON INDEX]:%d\n\n", buttonIndex);
    if (buttonIndex == 0)
    {
        // リモート通知登録申請
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

#pragma mark -【DT】PUSH通知設定、dvTokenID取得
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
                                    
//                                    // Push通知作成判断
//                                    [self DTPushMakeCalc];
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
                                
//                                // Push通知作成判断
//                                [self DTPushMakeCalc];
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


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (![error code] == 3010)
    {
        DLog(@"Error : %@ ",[error localizedDescription]);
    }
}


#pragma mark -【Sound】サウンド選択処理
- (void)SoundSelect:(NSInteger)number
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
    DLog(@"\n\n[SOUND CHECK BOX]:%d CLICKED\n[SOUND NUMBER]:%d\n[SOUND NAME]:%@\n[END DATE]:%@\n", number + 1,[userdefaults integerForKey:@"Sound Number"], [userdefaults stringForKey:@"Sound Name"], [NSDate dateWithTimeInterval:60*540 sinceDate:[userdefaults objectForKey:@"Test Date"]]);
    
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
        [self.delegate DTPushMake];
    }
    else
    {
        // DT:ON かつ ALARM:ON かつ PUSH IDが空　じゃないならスルー
        DLog(@"\n\n[DT ENABLE]:%d\n[ALARM ENABLE]:%d\n[PUSH ID]:%@\n[PUSH CALC]:NOT MAKE\n\n", [userdefaults boolForKey:@"DT Enabled"], [userdefaults boolForKey:@"Alarm Enabled"], [userdefaults stringForKey:@"Push ID"]);
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self.nadView setDelegate:nil]; // delegateにnilをセット
    self.nadView = nil; // プロパティ経由でrelease、nilをセット
    DLog();
}


@end
