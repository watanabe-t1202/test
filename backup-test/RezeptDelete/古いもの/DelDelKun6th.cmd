rem pause�Ƃ��̖₢���킹�n�̓X�P�W���[���N������ꍇ�͑S�ăR�����g�A�E�g���Ȃ��Ɨ��Ŏ~�܂����܂܂ɂȂ��Ď��s����˂񂾂���˂�
rem @echo #
rem @echo #################################################################
rem @echo #                                                               #
rem @echo #   �ق�Ƃ��Ɏ��s���܂����I�H �L�����Z���́~�ŕ��Ă�������   #
rem @echo #                                                               #
rem @echo #################################################################
rem @echo #
rem pause

rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\deldellog6.log
rem sqlcmd�ڑ����
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo2 -U kyusyo2 -P kyusyo2




rem SQLSERVER��sqlcmd�Őڑ����s��

rem    --�y�p�����[�^�z
rem    �폜�J�n �捞��            �F@DelStartYYYYMMDD
rem    �폜�I�� �捞��            �F@DelEndYYYYMMDD
rem    ����폜����������         �F@DelYoukyuCnt
rem    �R�~�b�g����������         �F@CommitCnt
rem    �R�~�b�g��̑҂�����(mm:ss)�F@CommitWaitFor
rem    ���v���Ď擾�R�~�b�g�� �F@ReStatusCnt
rem    �������f����               �F@LimitHHmm
rem    �J�n���Ώۃ��R�[�h�J�E���g �F@StartRecCnt
rem    �I�����Ώۃ��R�[�h�J�E���g �F@EndRecCnt
rem    �C���f�b�N�X�폜����       �F@IndexDel
rem    �C���f�b�N�X�쐬����       �F@IndexCre
rem    ���v���擾����           �F@Stat
rem
rem TOP(4,000��)��DELETE���s���A160,000������(40���[�v)�R�~�b�g���Ă���ƁATOP(4,000��)��DELETE���ǂ�ǂ�x���Ȃ�
rem TOP(4,000��)�����𒴂��͂��߁A39,024,000�������肩��5���ȏォ����A���̂��Ƃ͂ǂ�ǂ�x���Ȃ�
rem 3�������Ă݂�(78,130,597�|39,000,000��39,130,597)
rem�y6��ځz39,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F����(����ŃC���f�b�N�X�폜�O������)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F����(���񂾂���)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F����(UPDATE STATISTICS t_rezept)
rem      �������f�����F�\�肩�炢����02:30�ɂ͏I����ĂȂ��ƍ���
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'2130','1','1','1','1','1'" >> %fileNameLog%  2>&1

rem �T�[�r�X�ċN��
rem ������������_��
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem �����ݒ�
rem �O�t��HDD�h���C�u
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=D:
rem ���s�o�b�`�i�[��t�H���_
rem set BatPATH=F:\�����V�X�e��\SQLBackupData\Bat
set BatPATH=C:\temp
rem �o�͐�t�H���_
rem set OutPATH=%HDD_DRIVE%\�����V�X�e��\SQLBackupData
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
rem set LogPATH=F:\�����V�X�e��\SQLBackupData\Log
set LogPATH=%HDD_DRIVE%\dmp
rem �o�b�N�A�b�v�쐬
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_01.bak
rem ���O�t�@�C����
set LogFILE=Kyusyo6Backup.Log

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ���s�R�}���h�Ăяo��
%sqlcmd% -Q "BACKUP DATABASE KYUSYO2 TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>�@%LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem ����
rem �����ݒ�
rem �O�t��HDD�h���C�u
set HDD_DRIVE=D:


rem ���s�o�b�`�i�[��t�H���_
set BatPATH=C:\temp
rem �o�͐�t�H���_
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
set LogPATH=%HDD_DRIVE%\dmp

rem ���O�t�@�C����
set LogFILE=Kyusyo6Restore.Log
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_01.bak


rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO2 SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO2 FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%







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


