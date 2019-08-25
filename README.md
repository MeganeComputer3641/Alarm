# Alarm-App
ここでは、私の作った目覚ましアプリ（iOS）のソースコードを紹介しています。  
なお、作成したのが数年前の為、言語はObjective-C、最新の環境では非推奨(deprecated)となっているメソッドや記述が含まれていますので、あくまで参考程度にして頂ければと思います。m(_ _)m  
  
以下に、このアプリの主な機能を記載します。

* __アラーム機能__  
設定時刻がきたら、あらかじめ指定された目覚まし音(曲)が自動的に最大音量で流れます。  
アプリ起動中はマナーモードも無効となる為、うっかりマナーモードでも安心！

* __シェイク機能__  
アラームを止めるためには、一定回数本体を振らなくてはいけません。  
シェイクをせずにホーム画面へ戻った場合、通知でアラームが鳴ります。そう、”逃げちゃダメ”なんです。

* __Twitter連携機能__  
アラーム音が鳴ってから一定時間内にシェイクが達成されない場合、あらかじめ設定したtwitterアカウントに起きていない事がツイートされます。  
本当に起きたい日はtwitterのフォロワーに事前に伝えておけば、フォロワーが起こしてくれるかも？
  
## 環境/Version等
* 使用言語：Objective-C  
* Xcode：8.2  
* iOS：8.0　（Deployment Target）  

## 作者
Shuji Takahashi  
* Twitter：@Meganecomputer

