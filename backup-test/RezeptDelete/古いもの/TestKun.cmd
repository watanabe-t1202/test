rem ���팋�ʒl
set resNormal=0
rem �ُ팋�ʒl
set resError=99
rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\TestKun.log
rem �o�͂���t�@�C������_�ꎞ�t�@�C��
set fileNameTxt=res.txt
rem sqlcmd�ڑ����
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo3 -U kyusyo3 -P kyusyo3
rem sql�t�@�C��
set sqlFile=sample.sql
rem sql�p�����[�^
set sqlParam=20150101,20151231,78130597,40000,'0800'




rem SQLSERVER��sqlcmd�Őڑ����s��
%sqlcmd% -Q "EXEC TestKun 20150101,20151231,78130597,40000,'0800'" >> %fileNameLog%  2>&1

rem sqlcmd���s���ʂŏ����𕪊�
rem 0:����I�� ����ȊO:�ُ�I��
if %errorlevel% equ 0 (
 echo ����I�����܂����B>> %fileNameLog%


) else (
 echo �ُ�I�����܂����B>> %fileNameLog%


)


rem -------�����L�ڂ����܂�------

echo �v���O�������I�����܂����B


pause
exit


