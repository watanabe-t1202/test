rem pauseとかの問い合わせ系はスケジュール起動する場合は全てコメントアウトしないと裏で止まったままになって実行されねんだざんねん
rem @echo #
rem @echo #################################################################
rem @echo #                                                               #
rem @echo #   ほんとうに実行しますか！？ キャンセルは×で閉じてください   #
rem @echo #                                                               #
rem @echo #################################################################
rem @echo #
rem pause

rem sqlcmd接続情報
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo -U kyusyo -P kyusyo





rem 削除---------------------------------------------------------------
rem 出力するファイル名称_log
set fileNameLog=c:\temp\deldellog7_1.log


rem    --【パラメータ】
rem    削除開始 取込日            ：@DelStartYYYYMMDD  「20150101」
rem    削除終了 取込日            ：@DelEndYYYYMMDD    「20151231」
rem    今回削除したい件数         ：@DelYoukyuCnt      「39000000」
rem    コミットしたい件数         ：@CommitCnt         「160000」
rem    コミット後の待ち時間(mm:ss)：@CommitWaitFor     「00:00」
rem    統計情報再取得コミット回数 ：@ReStatusCnt       「0」
rem    処理中断時刻               ：@LimitHHmm         「0000」
rem    開始時対象レコードカウント ：@StartRecCnt       「1」
rem    終了時対象レコードカウント ：@EndRecCnt         「0」
rem    インデックス削除処理       ：@IndexDel          「1」Index2以外を削除
rem    インデックス作成処理       ：@IndexCre          「0」Index2以外を作成
rem    統計情報取得処理           ：@Stat              「2」T_REZEPTのテーブル統計のみ
rem
rem TOP(4,000件)をDELETE実行し、160,000件ずつ(40ループ)コミットしていると、TOP(4,000件)をDELETEがどんどん遅くなる
rem TOP(4,000件)が分を超えはじめ、39,024,000件あたりから5分以上かかり、このあとはどんどん遅くなる
rem 3分割してみる(78,130,597－39,000,000＝39,130,597)
rem【1回目】39,000,000件削除
rem      開始時対象レコードカウント：する(初回でインデックス削除前だから)
rem      終了時対象レコードカウント：しない(インデックスないから)
rem      インデックス削除処理：する(初回だから)
rem      インデックス作成処理：しない(次がはしるから)
rem      統計情報取得処理：する(UPDATE STATISTICS t_rezept)
rem      処理中断時刻：予定からいくと05:30には終わってないと困る
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','1','0','1','0','2'" >> %fileNameLog%  2>&1

rem サービス再起動--------------------------------------------------------
rem メモリ解放が狙い
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem バックアップ作成------------------------------------------------------
rem 引数設定
rem 外付けHDDドライブ
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=D:
rem 出力先フォルダ
rem set OutPATH=%HDD_DRIVE%\求償システム\SQLBackupData
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
rem set LogPATH=F:\求償システム\SQLBackupData\Log
set LogPATH=%HDD_DRIVE%\dmp
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak
rem ログファイル名
set LogFILE=Kyusyo7Backup1.Log

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem 実行コマンド呼び出し
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>　%LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 復元----------------------------------------------------------------
rem 引数設定
rem 外付けHDDドライブ
set HDD_DRIVE=D:


rem 出力先フォルダ
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
set LogPATH=%HDD_DRIVE%\dmp

rem ログファイル名
set LogFILE=Kyusyo7Restore1.Log
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak


rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 削除---------------------------------------------------------------
rem 出力するファイル名称_log
set fileNameLog=c:\temp\deldellog7_2.log

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
rem【1回目】39,000,000件削除
rem      開始時対象レコードカウント：する(初回でインデックス削除前だから)
rem      終了時対象レコードカウント：しない(インデックスないから)
rem      インデックス削除処理：する(初回だから)
rem      インデックス作成処理：しない(次がはしるから)
rem      統計情報取得処理：する(UPDATE STATISTICS t_rezept)
rem      処理中断時刻：予定からいくと05:30には終わってないと困る
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','0','0','0','0','2'" >> %fileNameLog%  2>&1




rem サービス再起動--------------------------------------------------------
rem メモリ解放が狙い
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem バックアップ作成------------------------------------------------------
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak
rem ログファイル名
set LogFILE=Kyusyo7Backup2.Log

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem 実行コマンド呼び出し
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>　%LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 復元----------------------------------------------------------------
rem 引数設定
rem 外付けHDDドライブ
set HDD_DRIVE=D:


rem 出力先フォルダ
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
set LogPATH=%HDD_DRIVE%\dmp

rem ログファイル名
set LogFILE=Kyusyo7Restore2.Log
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak


rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 削除---------------------------------------------------------------
rem 出力するファイル名称_log
set fileNameLog=c:\temp\deldellog7_2.log

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
rem【1回目】39,000,000件削除
rem      開始時対象レコードカウント：する(初回でインデックス削除前だから)
rem      終了時対象レコードカウント：しない(インデックスないから)
rem      インデックス削除処理：する(初回だから)
rem      インデックス作成処理：しない(次がはしるから)
rem      統計情報取得処理：する(UPDATE STATISTICS t_rezept)
rem      処理中断時刻：予定からいくと05:30には終わってないと困る
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','0','1','0','1','1'" >> %fileNameLog%  2>&1



rem サービス再起動--------------------------------------------------------
rem メモリ解放が狙い
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem バックアップ作成------------------------------------------------------
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak
rem ログファイル名
set LogFILE=Kyusyo7Backup3.Log

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem 実行コマンド呼び出し
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>　%LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%



rem 復元----------------------------------------------------------------
rem 引数設定
rem 外付けHDDドライブ
set HDD_DRIVE=D:


rem 出力先フォルダ
set OutPATH=%HDD_DRIVE%\dmp
rem ログフォルダ
set LogPATH=%HDD_DRIVE%\dmp

rem ログファイル名
set LogFILE=Kyusyo7Restore3.Log
rem 出力ファイル名
set BackupFILE=KyusyoData_tmp.bak

rem ログファイルに開始メッセージを出力
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% 開始 -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ログファイルに終了メッセージを出力
echo ----- %date% %time% 終了 -----  >> %LogPATH%\%LogFILE%





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


