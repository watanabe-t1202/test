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
set fileNameLog=c:\temp\deldellog2.log
rem sqlcmd接続情報
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo2 -U kyusyo2 -P kyusyo2


rem サービス起動(念のため)
net start "SQL Server (MSSQLSERVER)"


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
rem 3分割してみる(78,130,597－39,000,000－39,000,000＝130,597)
rem【2回目】39,000,000件削除
rem      開始時対象レコードカウント：しない(インデックスないから)
rem      終了時対象レコードカウント：しない(インデックスないから)
rem      インデックス削除処理：しない(途中だから)
rem      インデックス作成処理：しない(次がはしるから)
rem      統計情報取得処理：する(UPDATE STATISTICS t_rezept)
rem      処理中断時刻：予定からいくと20:30には終わってないと困る
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'2030','0','0','0','0','2'" >> %fileNameLog%  2>&1

rem サービス再起動
rem メモリ解放が狙い
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem sqlcmd実行結果で処理を分岐
rem 0:正常終了 それ以外:異常終了
if %errorlevel% equ 0 (
 echo 正常終了しました。>> %fileNameLog%


) else (
 echo 異常終了しました。>> %fileNameLog%


)


rem -------処理記載ここまで------

echo プログラムが終了しました。


rem pause
exit


