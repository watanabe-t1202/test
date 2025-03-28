rem pauseとかの問い合わせ系はスケジュール起動する場合は全てコメントアウトしないと裏で止まったままになって実行されねんだざんねん
rem @echo #
rem @echo #################################################################
rem @echo #                                                               #
rem @echo #   ほんとうに実行しますか！？ キャンセルは×で閉じてください   #
rem @echo #                                                               #
rem @echo #################################################################
rem @echo #
rem pause

rem 出力するファイル名称_log
set fileNameLog=c:\temp\deldellog6.log
rem sqlcmd接続情報
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo2 -U kyusyo2 -P kyusyo2




rem SQLSERVERにsqlcmdで接続を行う

rem    --【パラメータ】
rem    削除開始 取込日            ：@DelStartYYYYMMDD
rem    削除終了 取込日            ：@DelEndYYYYMMDD
rem    今回削除したい件数         ：@DelYoukyuCnt
rem    コミットしたい件数         ：@CommitCnt
rem    コミット後の待ち時間(mm:ss)：@CommitWaitFor
rem    統計情報再取得コミット回数 ：@ReStatusCnt
rem    処理中断時刻               ：@LimitHHmm
rem    開始時対象レコードカウント ：@StartRecCnt
rem    終了時対象レコードカウント ：@EndRecCnt
rem    インデックス削除処理       ：@IndexDel
rem    インデックス作成処理       ：@IndexCre
rem    統計情報取得処理           ：@Stat
rem
rem TOP(4,000件)をDELETE実行し、160,000件ずつ(40ループ)コミットしていると、TOP(4,000件)をDELETEがどんどん遅くなる
rem TOP(4,000件)が分を超えはじめ、39,024,000件あたりから5分以上かかり、このあとはどんどん遅くなる
rem 3分割してみる(78,130,597－39,000,000＝39,130,597)
rem【6回目】39,000,000件削除
rem      開始時対象レコードカウント：する(初回でインデックス削除前だから)
rem      終了時対象レコードカウント：しない(インデックスないから)
rem      インデックス削除処理：する(初回だから)
rem      インデックス作成処理：しない(次がはしるから)
rem      統計情報取得処理：する(UPDATE STATISTICS t_rezept)
rem      処理中断時刻：予定からいくと02:30には終わってないと困る
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'2130','1','1','1','1','1'" >> %fileNameLog%  2>&1

rem サービス再起動
rem メモリ解放が狙い
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem 引数設定
rem 外付けHDDドライブ
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=D:
rem 実行バッチ格納先フォルダ
rem set BatPATH=F:\求償システム\SQLBackupData\Bat
set BatPATH=C:\temp
rem 出力先フォルダ
rem set OutPATH=%HDD_DRIVE%\求償システム\SQLBackupData
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
rem set LogPATH=F:\求償システム\SQLBackupData\Log
set LogPATH=%HDD_DRIVE%\dmp
rem バックアップ作成
rem 出力ファイル名
set BackupFILE=KyusyoData_01.bak
rem ログファイル名
set LogFILE=Kyusyo6Backup.Log

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem 実行コマンド呼び出し
%sqlcmd% -Q "BACKUP DATABASE KYUSYO2 TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>　%LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 復元
rem 引数設定
rem 外付けHDDドライブ
set HDD_DRIVE=D:


rem 実行バッチ格納先フォルダ
set BatPATH=C:\temp
rem 出力先フォルダ
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
set LogPATH=%HDD_DRIVE%\dmp

rem ログファイル名
set LogFILE=Kyusyo6Restore.Log
rem 出力ファイル名
set BackupFILE=KyusyoData_01.bak


rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO2 SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO2 FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%







rem sqlcmd実行結果で処理を分岐
rem 0:正常終了 それ以外:異常終了
if %errorlevel% equ 0 (
 echo 正常終了しました。>> %fileNameLog%


) else (
 echo 異常終了しました。>> %fileNameLog%


)


rem -------処理記載ここまで------

echo プログラムが終了しました。


pause
exit


