rem pause�Ƃ��̖₢���킹�n�̓X�P�W���[���N������ꍇ�͑S�ăR�����g�A�E�g���Ȃ��Ɨ��Ŏ~�܂����܂܂ɂȂ��Ď��s����˂񂾂���˂�
rem @echo #
rem @echo #################################################################
rem @echo #                                                               #
rem @echo #   �ق�Ƃ��Ɏ��s���܂����I�H �L�����Z���́~�ŕ��Ă�������   #
rem @echo #                                                               #
rem @echo #################################################################
rem @echo #
rem pause

rem sqlcmd�ڑ����
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo -U kyusyo -P kyusyo





rem �폜---------------------------------------------------------------
rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\deldellog7_1.log


rem    --�y�p�����[�^�z
rem    �폜�J�n �捞��            �F@DelStartYYYYMMDD  �u20150101�v
rem    �폜�I�� �捞��            �F@DelEndYYYYMMDD    �u20151231�v
rem    ����폜����������         �F@DelYoukyuCnt      �u39000000�v
rem    �R�~�b�g����������         �F@CommitCnt         �u160000�v
rem    �R�~�b�g��̑҂�����(mm:ss)�F@CommitWaitFor     �u00:00�v
rem    ���v���Ď擾�R�~�b�g�� �F@ReStatusCnt       �u0�v
rem    �������f����               �F@LimitHHmm         �u0000�v
rem    �J�n���Ώۃ��R�[�h�J�E���g �F@StartRecCnt       �u1�v
rem    �I�����Ώۃ��R�[�h�J�E���g �F@EndRecCnt         �u0�v
rem    �C���f�b�N�X�폜����       �F@IndexDel          �u1�vIndex2�ȊO���폜
rem    �C���f�b�N�X�쐬����       �F@IndexCre          �u0�vIndex2�ȊO���쐬
rem    ���v���擾����           �F@Stat              �u2�vT_REZEPT�̃e�[�u�����v�̂�
rem
rem TOP(4,000��)��DELETE���s���A160,000������(40���[�v)�R�~�b�g���Ă���ƁATOP(4,000��)��DELETE���ǂ�ǂ�x���Ȃ�
rem TOP(4,000��)�����𒴂��͂��߁A39,024,000�������肩��5���ȏォ����A���̂��Ƃ͂ǂ�ǂ�x���Ȃ�
rem 3�������Ă݂�(78,130,597�|39,000,000��39,130,597)
rem�y1��ځz39,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F����(����ŃC���f�b�N�X�폜�O������)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F����(���񂾂���)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F����(UPDATE STATISTICS t_rezept)
rem      �������f�����F�\�肩�炢����05:30�ɂ͏I����ĂȂ��ƍ���
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','1','0','1','0','2'" >> %fileNameLog%  2>&1

rem �T�[�r�X�ċN��--------------------------------------------------------
rem ������������_��
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem �o�b�N�A�b�v�쐬------------------------------------------------------
rem �����ݒ�
rem �O�t��HDD�h���C�u
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=D:
rem �o�͐�t�H���_
rem set OutPATH=%HDD_DRIVE%\�����V�X�e��\SQLBackupData
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
rem set LogPATH=F:\�����V�X�e��\SQLBackupData\Log
set LogPATH=%HDD_DRIVE%\dmp
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak
rem ���O�t�@�C����
set LogFILE=Kyusyo7Backup1.Log

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ���s�R�}���h�Ăяo��
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>�@%LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem ����----------------------------------------------------------------
rem �����ݒ�
rem �O�t��HDD�h���C�u
set HDD_DRIVE=D:


rem �o�͐�t�H���_
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
set LogPATH=%HDD_DRIVE%\dmp

rem ���O�t�@�C����
set LogFILE=Kyusyo7Restore1.Log
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak


rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem �폜---------------------------------------------------------------
rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\deldellog7_2.log

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
rem�y1��ځz39,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F����(����ŃC���f�b�N�X�폜�O������)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F����(���񂾂���)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F����(UPDATE STATISTICS t_rezept)
rem      �������f�����F�\�肩�炢����05:30�ɂ͏I����ĂȂ��ƍ���
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','0','0','0','0','2'" >> %fileNameLog%  2>&1




rem �T�[�r�X�ċN��--------------------------------------------------------
rem ������������_��
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem �o�b�N�A�b�v�쐬------------------------------------------------------
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak
rem ���O�t�@�C����
set LogFILE=Kyusyo7Backup2.Log

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ���s�R�}���h�Ăяo��
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>�@%LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem ����----------------------------------------------------------------
rem �����ݒ�
rem �O�t��HDD�h���C�u
set HDD_DRIVE=D:


rem �o�͐�t�H���_
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
set LogPATH=%HDD_DRIVE%\dmp

rem ���O�t�@�C����
set LogFILE=Kyusyo7Restore2.Log
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak


rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem �폜---------------------------------------------------------------
rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\deldellog7_2.log

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
rem�y1��ځz39,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F����(����ŃC���f�b�N�X�폜�O������)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F����(���񂾂���)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F����(UPDATE STATISTICS t_rezept)
rem      �������f�����F�\�肩�炢����05:30�ɂ͏I����ĂȂ��ƍ���
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'0000','0','1','0','1','1'" >> %fileNameLog%  2>&1



rem �T�[�r�X�ċN��--------------------------------------------------------
rem ������������_��
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem �o�b�N�A�b�v�쐬------------------------------------------------------
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak
rem ���O�t�@�C����
set LogFILE=Kyusyo7Backup3.Log

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ���s�R�}���h�Ăяo��
%sqlcmd% -Q "BACKUP DATABASE KYUSYO TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>�@%LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%



rem ����----------------------------------------------------------------
rem �����ݒ�
rem �O�t��HDD�h���C�u
set HDD_DRIVE=D:


rem �o�͐�t�H���_
set OutPATH=%HDD_DRIVE%\dmp
rem ���O�t�H���_
set LogPATH=%HDD_DRIVE%\dmp

rem ���O�t�@�C����
set LogFILE=Kyusyo7Restore3.Log
rem �o�̓t�@�C����
set BackupFILE=KyusyoData_tmp.bak

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
%sqlcmd% -Q "ALTER DATABASE KYUSYO SET OFFLINE WITH ROLLBACK IMMEDIATE;RESTORE DATABASE KYUSYO FROM DISK = '%OutPATH%\%BackupFILE%' WITH REPLACE;" -b >> %LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%





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


