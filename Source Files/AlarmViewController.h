//
//  AlarmViewController.h
//  Alarm
//
//  Created by Shuji Takahashi on 2016/12/26.
//  Copyright (c) 2016年 Meganecomputer. All rights reserved.
//
//


#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>
#import "NADView.h"
#import "SettingsViewController.h"


@interface AlarmViewController : GAITrackedViewController <NADViewDelegate, SettingsViewControllerDelegate, AVAudioPlayerDelegate, NSFileManagerDelegate>
{
    BOOL alarmEnabled; //アラームの状態(ON/OFF)
    BOOL DTEnabled; //デラオキツイート状態(ON/OFF)
    BOOL ACEnabled; //Twitterアカウント(登録・許可済み/未登録・未許可)
    BOOL wakeUp; //アラーム再生判断
    BOOL notif; //アラーム通知作成状況
    AVAudioPlayer *alarmPlayer; //アラーム音再生インスタンス
    AVAudioPlayer *testPlayer; //試聴音再生インスタンス
    NSString *testSoundName; //試聴サウンド名
    NSDate *alarmTime; //アラーム時刻
    int alarmHour; //アラーム時刻の時数
    int alarmMin; //アラーム時刻の分数
    int remainHour; //アラームまでの残り時数
    int remainMin; //アラームまでの残り分数
    int shakeNumber; //シェイク回数
    CMMotionManager *motionManager; //加速度計測
    UIButton *closeButton; //広告削除ボタン
    UILabel *buttonTitle; //広告削除ボタンのラベル
    UIButton *buttonbutton;
}

@property (nonatomic, strong) NADView *nadView1; //中央広告(320×250)
@property (nonatomic, strong) NADView *nadView2; //下部広告(320×50)

@property (weak, nonatomic) IBOutlet UIImageView *yearNum1;
@property (weak, nonatomic) IBOutlet UIImageView *yearNum2;
@property (weak, nonatomic) IBOutlet UIImageView *yearNum3;
@property (weak, nonatomic) IBOutlet UIImageView *yearNum4;
@property (weak, nonatomic) IBOutlet UIImageView *monthNum1;
@property (weak, nonatomic) IBOutlet UIImageView *monthNum2;
@property (weak, nonatomic) IBOutlet UIImageView *dateNum1;
@property (weak, nonatomic) IBOutlet UIImageView *dateNum2;
@property (weak, nonatomic) IBOutlet UIImageView *hourNum1;
@property (weak, nonatomic) IBOutlet UIImageView *hourNum2;
@property (weak, nonatomic) IBOutlet UIImageView *minNum1;
@property (weak, nonatomic) IBOutlet UIImageView *minNum2;
@property (weak, nonatomic) IBOutlet UIImageView *shakeNum1;
@property (weak, nonatomic) IBOutlet UIImageView *shakeNum2;
@property (weak, nonatomic) IBOutlet UIImageView *shakeNum3;
@property (weak, nonatomic) IBOutlet UIImageView *shakeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *meganeicon;
@property (weak, nonatomic) IBOutlet UIImageView *alarmHour1;
@property (weak, nonatomic) IBOutlet UIImageView *alarmHour2;
@property (weak, nonatomic) IBOutlet UIImageView *alarmMin1;
@property (weak, nonatomic) IBOutlet UIImageView *alarmMin2;
@property (weak, nonatomic) IBOutlet UIImageView *remainLabel;
@property (weak, nonatomic) IBOutlet UIView *remainTimeView;
@property (weak, nonatomic) IBOutlet UIImageView *remainHour1;
@property (weak, nonatomic) IBOutlet UIImageView *remainHour2;
@property (weak, nonatomic) IBOutlet UIImageView *remainMin1;
@property (weak, nonatomic) IBOutlet UIImageView *remainMin2;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (weak, nonatomic) IBOutlet UIButton *SetButton;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIView *tutorialView;


- (IBAction)batsuButtonClicked; // 誘導画面削除

- (IBAction)alarmSet; // Alarm ON/OFF切り替え
- (IBAction)didDoneButtonClicked:(id)sender; // DatePickerでDoneボタン選択時の処理
- (IBAction)didCancelButtonClicked:(id)sender; //DatePickerでCancel時の処理


- (void)setAlarmItems; //状態別の画面設定
- (void)saveUserDefaults; //ユーザ・デフォルトの保存
- (void)loadUserDefaults; //ユーザ・デフォルトの読み込み
- (void)alarmNotification; // アラーム通知生成
- (void)alarmEdit; // Alarm時間設定開始
- (void)startShake; //シェイク検出開始メソッド
- (void)shake:(CMAccelerometerData *)data; //シェイク検出時の処理
- (void)dtCheck; //デラオキツイート可能/不可能 判定
- (void)dtPushMake; //DTPUSH作成
- (void)adViewPause; // バックグラウンド移行時の広告定期ロード中断
- (void)adViewResume; // バックグラウンド復帰時の広告定期ロード再開

//- (BOOL)DTPushMakeCalc; //DTPUSH作成判断

//- (void)PushCreateInBackgroundTask;

@end
