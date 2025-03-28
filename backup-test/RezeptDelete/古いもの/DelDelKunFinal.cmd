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
set fileNameLog=c:\temp\deldellogFinal.log


rem    @DelStartYYYYMMDD NVARCHAR(8) --削除開始 取込日            ：YYYYMMDD
rem   ,@DelEndYYYYMMDD   NVARCHAR(8) --削除終了 取込日            ：YYYYMMDD
rem   ,@DelYoukyuCnt     int         --今回削除したい件数         ：
rem   ,@CommitCnt        int         --コミットしたい件数         ：TOP(4000)をDELETEループしている。削除件数が指定件数に達したらコミットする。コミット毎に削除件数はリセットする。
rem   ,@CommitWaitFor    NVARCHAR(5) --コミット後の待ち時間(mm:ss)：コミット後に処理を休止する時間を設定する。最小設定1秒(00:01)
rem   ,@ReStatusCnt      int         --統計情報再取得コミット回数 ：コミット回数毎にT_REZEPTの統計情報を取得できる。コミット回数が指定回数に達したら統計情報取得する。統計情報取得後はコミット回数をリセットする。
rem   ,@LimitYYYYMMDD    NVARCHAR(8) --処理中断日                 ：削除ループを中断する年月日を指定できる。指定しない場合は'yyyy-MM-dd'とする。
rem   ,@LimitHHmm        NVARCHAR(5) --処理中断時刻               ：削除ループを中断する時刻を指定できる。指定しない場合は'9999'とする。
rem   ,@StartRecCnt      NVARCHAR(1) --開始時対象レコードカウント ：最初に削除対象の件数を取得するか('0':取得しない/'1':取得する)
rem   ,@EndRecCnt        NVARCHAR(1) --終了時対象レコードカウント ：最後に削除対象の件数を取得するか('0':取得しない/'1':取得する)
rem   ,@IndexDel         NVARCHAR(1) --インデックス削除処理       ：インデックスを削除するか('0':削除しない/'1':削除する)※Index2は除く
rem   ,@IndexCre         NVARCHAR(1) --インデックス作成処理       ：インデックスを作成するか('0':作成しない/'1':作成する)※Index2は除く
rem   ,@Stat             NVARCHAR(1) --統計情報取得処理           ：最後に統計情報を取得するか('0':取得しない/'1':全体の統計情報を取得する/'2':T_REZEPTのみ統計情報を取得する)
rem   ,@Comp             NVARCHAR(1) --DB圧縮                     ：最後にログファイル、データファイルを圧縮するか('0':圧縮しない/'1':圧縮する)
rem
rem TOP(4,000件)をDELETE実行し、160,000件ずつ(40ループ)コミットしていると、TOP(4,000件)をDELETEがどんどん遅くなる
rem TOP(4,000件)が分を超えはじめ、39,024,000件あたりから5分以上かかり、このあとはどんどん遅くなる
rem 3分割してみる(78,130,597－39,000,000＝39,130,597)

%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,79000000,160000,'00:00',0,'2025-01-06','0100','1','1','1','1','1','1'" >> %fileNameLog%  2>&1





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


