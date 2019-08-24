//
//  SettingsViewController.h
//  Alarm
//
//  Created by Megane.computer on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//


#import "NADView.h"
#import "CheckboxButton.h"


// 宣言で使用するクラス
@class SettingsViewController;


// 使用するデリゲートメソッド
@protocol SettingsViewControllerDelegate

- (void)SettingsViewControllerDidFinish:(SettingsViewController *)controller;
- (void)dtPushMake;

@end


@interface SettingsViewController : GAITrackedViewController <NADViewDelegate>
{
    BOOL DTEnabled; //デラオキツイート状態(ON/OFF)
    BOOL ACEnabled; //Twitterアカウント(登録・許可済み/未登録・未許可)
    NSArray *TWLabelArray; //TweetWords画面表示ラベル
    NSArray *TWwordsArray; //TweetWords
    NSArray *SoundNameArray; //サウンド名
}

@property (weak, nonatomic) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, strong) NADView *nadView;

@property (weak, nonatomic) IBOutlet UIView *DTview;
@property (weak, nonatomic) IBOutlet CheckboxButton *DTcheckButton;

// デラオキツイート設定項目view
@property (weak, nonatomic) IBOutlet UILabel *AClabel;
@property (weak, nonatomic) IBOutlet UIButton *ACsettingButton;
@property (weak, nonatomic) IBOutlet UIView *DTsetview;
@property (weak, nonatomic) IBOutlet UILabel *TWwords1;
@property (weak, nonatomic) IBOutlet UILabel *TWwords2;
@property (weak, nonatomic) IBOutlet UILabel *TWwords3;
@property (weak, nonatomic) IBOutlet UILabel *TWwords4;
@property (weak, nonatomic) IBOutlet UILabel *TWwords5;
@property (weak, nonatomic) IBOutlet CheckboxButton *TWcheckbox1;
@property (weak, nonatomic) IBOutlet CheckboxButton *TWcheckbox2;
@property (weak, nonatomic) IBOutlet CheckboxButton *TWcheckbox3;
@property (weak, nonatomic) IBOutlet CheckboxButton *TWcheckbox4;
@property (weak, nonatomic) IBOutlet CheckboxButton *TWcheckbox5;

// サウンド設定項目view
@property (weak, nonatomic) IBOutlet UIView *Soundsetview;
@property (weak, nonatomic) IBOutlet UILabel *SLabel1;
@property (weak, nonatomic) IBOutlet UILabel *SLabel2;
@property (weak, nonatomic) IBOutlet UILabel *SLabel3;
@property (weak, nonatomic) IBOutlet UILabel *SLabel4;
@property (weak, nonatomic) IBOutlet UILabel *SLabel5;
@property (weak, nonatomic) IBOutlet CheckboxButton *Scheckbox1;
@property (weak, nonatomic) IBOutlet CheckboxButton *Scheckbox2;
@property (weak, nonatomic) IBOutlet CheckboxButton *Scheckbox3;
@property (weak, nonatomic) IBOutlet CheckboxButton *Scheckbox4;
@property (weak, nonatomic) IBOutlet CheckboxButton *Scheckbox5;



// Settings画面遷移メソッド
- (IBAction)Back:(id)sender;

// デラオキツイート
- (IBAction)ACButtonClicked;
- (IBAction)DTButtonClicked;
- (IBAction)DTInfoClicked;
- (IBAction)TWcheckbox1Clicked;
- (IBAction)TWcheckbox2Clicked;
- (IBAction)TWcheckbox3Clicked;
- (IBAction)TWcheckbox4Clicked;
- (IBAction)TWcheckbox5Clicked;
- (IBAction)TW4InfoClicked;
- (IBAction)TW5InfoClicked;

// サウンド設定
- (IBAction)Scheckbox1Clicked;
- (IBAction)Scheckbox2Clicked;
- (IBAction)Scheckbox3Clicked;
- (IBAction)Scheckbox4Clicked;
- (IBAction)Scheckbox5Clicked;


@end
