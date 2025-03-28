@echo off
rem ----------------------------------------------------------------------------
rem システム名　：求償システム
rem 
rem 処理名　　　：求償データバックアップ処理　（KyusyoBackupBatch.bat)
rem 処理方法　　：スケジューラによる自動実行
rem 
rem 処理概要　　：①sqlcmdによるデータベースバックアップ
rem 　　　　　　：－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
rem 　　　　　　：－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
rem 修正履歴　　：2015.04.21 新規作成
rem 　　　　　　：2015.04.28 外付けHDDドライブを名前に変更対応
rem ----------------------------------------------------------------------------
rem 例月の連携も連携前(金曜日)、連携後(日曜日)にバックアップするスケジュール(バックアップ想定3時間)
rem 例月連携は想定21時間

rem 引数設定
rem 外付けHDDドライブ
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=\\Landisk-a538b2\求償


rem 実行バッチ格納先フォルダ
rem set BatPATH=F:\求償システム\SQLBackupData\Bat
set BatPATH=C:\求償システム\SQLBackupData\Bat
rem 出力先フォルダ
rem set OutPATH=%HDD_DRIVE%\求償システム\SQLBackupData
set OutPATH=%HDD_DRIVE%\SQLBackupData
rem ログフォルダ
rem set LogPATH=F:\求償システム\SQLBackupData\Log
set LogPATH=C:\求償システム\SQLBackupData\Log

rem SQLServer設定
rem DBサーバーホスト名\SQLServerインスタンス
rem set HostNAME=K-KYUSYO01\MSSQLSERVER,1433
set HostNAME=K-kyusyo2021-sv\MSSQLSERVER,1433
rem データベース名
set DbNAME=KYUSYO
rem SQLServer認証ユーザー名
set UserNAME=kyusyo
rem パスワード
set UserPWD=kyusyo
rem ログファイル名
set LogFILE=KyusyoBackup.Log

rem 実行確認メッセージ
Setlocal
echo %date% %time%
echo データベースバックアップを開始しています。しばらくお待ちください。
echo   終了時には自動的にバックアップ画面が終了します。
rem echo;
rem echo データベースバックアップを実行しますか?【Y/N】
rem set /p c=
rem if "%c%"=="Y" GOTO CONTINUE
rem if "%c%"=="y" GOTO CONTINUE
rem Y,y以外の場合は処理終了。
rem echo 処理を中断しました。
rem GOTO EXIT_INFO
rem :CONTINUE

rem 外付けHDDドライブ存在チェック
if not exist %HDD_DRIVE% (
echo ----- %date% %time% HDDドライブに接続できません。 -----  >> %LogPATH%\%LogFILE%
echo ----- %date% %time% HDDドライブの接続、電源の確認を行ってください。 -----  >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 処理を中断しました。 -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO
)

rem ログフォルダ確認
IF NOT EXIST "%LogPATH%" (
    mkdir %LogPATH%
)
rem 出力フォルダ確認
IF NOT EXIST %OutPATH% (
    mkdir %OutPATH%
)

rem 現在時刻をYYYYMMDDHHMMSS形式で取得する
rem set time_tmp=%time: =0%
rem set now=%date:/=%%time_tmp:~0,2%%time_tmp:~3,2%%time_tmp:~6,2%

rem 曜日ローテーションでバックアップする(実質土曜日スケジュールなし)(直近１週間分)
rem 日曜日にバックアップすることで例月の処理後のバックアップもとれる
cscript /b C:\求償システム\SQLBackupData\Bat\weekday.vbs  
if %errorlevel%==7 set WDAY=6_SAT
if %errorlevel%==6 set WDAY=5_FRI
if %errorlevel%==5 set WDAY=4_THU
if %errorlevel%==4 set WDAY=3_WED
if %errorlevel%==3 set WDAY=2_TUE
if %errorlevel%==2 set WDAY=1_MON
if %errorlevel%==1 set WDAY=7_SUN

rem 出力ファイル名
rem set BackupFILE=KyusyoData_%now%.bak
rem 出力ファイル名(曜日毎)KyusyoData_n_XXX.bak
set BackupFILE=KyusyoData_%WDAY%.bak

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem 実行コマンド呼び出し
sqlcmd -S %HostNAME% -U %UserNAME% -P %UserPWD% -Q "BACKUP DATABASE %DbNAME% TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>　%LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%

rem コマンド実行確認
if not "%ERRORLEVEL%"  == "0" GOTO ERR_INFO

rem 正常終了
rem becho;
rem echo;
rem echo ----- 正常終了しました。-----
rem echo;
rem echo;
echo ----- %date% %time% 正常終了しました。 -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO

:ERR_INFO
rem 異常終了
rem echo;
rem echo;
rem echo ***** 異常終了しました。*****
rem echo;
rem echo;
echo ----- %date% %time% ***** 異常終了しました。***** -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO

:EXIT_INFO
rem Setlocal
rem echo;
rem echo 画面を閉じるには「Enter」キーを押してください。
rem set /p c=
exit
