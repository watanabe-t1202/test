@echo off
rem ----------------------------------------------------------------------------
rem �V�X�e�����@�F�����V�X�e��
rem 
rem �������@�@�@�F�����f�[�^�o�b�N�A�b�v�����@�iKyusyoBackupBatch.bat)
rem �������@�@�@�F�X�P�W���[���ɂ�鎩�����s
rem 
rem �����T�v�@�@�F�@sqlcmd�ɂ��f�[�^�x�[�X�o�b�N�A�b�v
rem �@�@�@�@�@�@�F�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
rem �@�@�@�@�@�@�F�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|�|
rem �C�������@�@�F2015.04.21 �V�K�쐬
rem �@�@�@�@�@�@�F2015.04.28 �O�t��HDD�h���C�u�𖼑O�ɕύX�Ή�
rem ----------------------------------------------------------------------------
rem �ጎ�̘A�g���A�g�O(���j��)�A�A�g��(���j��)�Ƀo�b�N�A�b�v����X�P�W���[��(�o�b�N�A�b�v�z��3����)
rem �ጎ�A�g�͑z��21����

rem �����ݒ�
rem �O�t��HDD�h���C�u
rem set HDD_DRIVE=\\LS-WXBL294\share
set HDD_DRIVE=\\Landisk-a538b2\����


rem ���s�o�b�`�i�[��t�H���_
rem set BatPATH=F:\�����V�X�e��\SQLBackupData\Bat
set BatPATH=C:\�����V�X�e��\SQLBackupData\Bat
rem �o�͐�t�H���_
rem set OutPATH=%HDD_DRIVE%\�����V�X�e��\SQLBackupData
set OutPATH=%HDD_DRIVE%\SQLBackupData
rem ���O�t�H���_
rem set LogPATH=F:\�����V�X�e��\SQLBackupData\Log
set LogPATH=C:\�����V�X�e��\SQLBackupData\Log

rem SQLServer�ݒ�
rem DB�T�[�o�[�z�X�g��\SQLServer�C���X�^���X
rem set HostNAME=K-KYUSYO01\MSSQLSERVER,1433
set HostNAME=K-kyusyo2021-sv\MSSQLSERVER,1433
rem �f�[�^�x�[�X��
set DbNAME=KYUSYO
rem SQLServer�F�؃��[�U�[��
set UserNAME=kyusyo
rem �p�X���[�h
set UserPWD=kyusyo
rem ���O�t�@�C����
set LogFILE=KyusyoBackup.Log

rem ���s�m�F���b�Z�[�W
Setlocal
echo %date% %time%
echo �f�[�^�x�[�X�o�b�N�A�b�v���J�n���Ă��܂��B���΂炭���҂����������B
echo   �I�����ɂ͎����I�Ƀo�b�N�A�b�v��ʂ��I�����܂��B
rem echo;
rem echo �f�[�^�x�[�X�o�b�N�A�b�v�����s���܂���?�yY/N�z
rem set /p c=
rem if "%c%"=="Y" GOTO CONTINUE
rem if "%c%"=="y" GOTO CONTINUE
rem Y,y�ȊO�̏ꍇ�͏����I���B
rem echo �����𒆒f���܂����B
rem GOTO EXIT_INFO
rem :CONTINUE

rem �O�t��HDD�h���C�u���݃`�F�b�N
if not exist %HDD_DRIVE% (
echo ----- %date% %time% HDD�h���C�u�ɐڑ��ł��܂���B -----  >> %LogPATH%\%LogFILE%
echo ----- %date% %time% HDD�h���C�u�̐ڑ��A�d���̊m�F���s���Ă��������B -----  >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �����𒆒f���܂����B -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO
)

rem ���O�t�H���_�m�F
IF NOT EXIST "%LogPATH%" (
    mkdir %LogPATH%
)
rem �o�̓t�H���_�m�F
IF NOT EXIST %OutPATH% (
    mkdir %OutPATH%
)

rem ���ݎ�����YYYYMMDDHHMMSS�`���Ŏ擾����
rem set time_tmp=%time: =0%
rem set now=%date:/=%%time_tmp:~0,2%%time_tmp:~3,2%%time_tmp:~6,2%

rem �j�����[�e�[�V�����Ńo�b�N�A�b�v����(�����y�j���X�P�W���[���Ȃ�)(���߂P�T�ԕ�)
rem ���j���Ƀo�b�N�A�b�v���邱�Ƃŗጎ�̏�����̃o�b�N�A�b�v���Ƃ��
cscript /b C:\�����V�X�e��\SQLBackupData\Bat\weekday.vbs  
if %errorlevel%==7 set WDAY=6_SAT
if %errorlevel%==6 set WDAY=5_FRI
if %errorlevel%==5 set WDAY=4_THU
if %errorlevel%==4 set WDAY=3_WED
if %errorlevel%==3 set WDAY=2_TUE
if %errorlevel%==2 set WDAY=1_MON
if %errorlevel%==1 set WDAY=7_SUN

rem �o�̓t�@�C����
rem set BackupFILE=KyusyoData_%now%.bak
rem �o�̓t�@�C����(�j����)KyusyoData_n_XXX.bak
set BackupFILE=KyusyoData_%WDAY%.bak

rem ���O�t�@�C���ɊJ�n���b�Z�[�W���o��
echo; >> %LogPATH%\%LogFILE%
echo ----- %date% %time% �J�n -----  >> %LogPATH%\%LogFILE%
echo %BackupFILE% >> %LogPATH%\%LogFILE%

rem ���s�R�}���h�Ăяo��
sqlcmd -S %HostNAME% -U %UserNAME% -P %UserPWD% -Q "BACKUP DATABASE %DbNAME% TO DISK = '%OutPATH%\%BackupFILE%' WITH INIT;" -b >>�@%LogPATH%\%LogFILE%

rem ���O�t�@�C���ɏI�����b�Z�[�W���o��
echo ----- %date% %time% �I�� -----  >> %LogPATH%\%LogFILE%

rem �R�}���h���s�m�F
if not "%ERRORLEVEL%"  == "0" GOTO ERR_INFO

rem ����I��
rem becho;
rem echo;
rem echo ----- ����I�����܂����B-----
rem echo;
rem echo;
echo ----- %date% %time% ����I�����܂����B -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO

:ERR_INFO
rem �ُ�I��
rem echo;
rem echo;
rem echo ***** �ُ�I�����܂����B*****
rem echo;
rem echo;
echo ----- %date% %time% ***** �ُ�I�����܂����B***** -----  >> %LogPATH%\%LogFILE%
GOTO EXIT_INFO

:EXIT_INFO
rem Setlocal
rem echo;
rem echo ��ʂ����ɂ́uEnter�v�L�[�������Ă��������B
rem set /p c=
exit
