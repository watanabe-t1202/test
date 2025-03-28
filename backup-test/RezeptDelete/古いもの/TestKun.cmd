rem 正常結果値
set resNormal=0
rem 異常結果値
set resError=99
rem 出力するファイル名称_log
set fileNameLog=c:\temp\TestKun.log
rem 出力するファイル名称_一時ファイル
set fileNameTxt=res.txt
rem sqlcmd接続情報
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo3 -U kyusyo3 -P kyusyo3
rem sqlファイル
set sqlFile=sample.sql
rem sqlパラメータ
set sqlParam=20150101,20151231,78130597,40000,'0800'




rem SQLSERVERにsqlcmdで接続を行う
%sqlcmd% -Q "EXEC TestKun 20150101,20151231,78130597,40000,'0800'" >> %fileNameLog%  2>&1

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


