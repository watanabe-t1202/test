rem pause�Ƃ��̖₢���킹�n�̓X�P�W���[���N������ꍇ�͑S�ăR�����g�A�E�g���Ȃ��Ɨ��Ŏ~�܂����܂܂ɂȂ��Ď��s����˂񂾂���˂�
@echo #
@echo #################################################################
@echo #                                                               #
@echo #   �ق�Ƃ��Ɏ��s���܂����I�H �L�����Z���́~�ŕ��Ă�������   #
@echo #                                                               #
@echo #################################################################
@echo #
pause

rem ���팋�ʒl
set resNormal=0
rem �ُ팋�ʒl
set resError=99
rem �o�͂���t�@�C������_log
set fileNameLog=c:\temp\test.log
rem �o�͂���t�@�C������_�ꎞ�t�@�C��
set fileNameTxt=res.txt
rem sqlcmd�ڑ����
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo -U kyusyo -P kyusyo
rem sql�t�@�C��
set sqlFile=sample.sql
rem sql�p�����[�^
set sqlParam='abc101'




rem SQLSERVER��sqlcmd�Őڑ����s��
rem 20241210%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,78130597,40000,'00:01',250,'9999'" >> %fileNameLog%  2>&1
rem %sqlcmd% -Q "EXEC DelDelKun 20150201,20150231,18250268,4000,'00:00',0,'9999'" >> %fileNameLog%  2>&1
rem %sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,78130597,160000,'00:00',0,'9999'" >> %fileNameLog%  2>&1

rem TOP(4,000��)��DELETE���s���A160,000������(40���[�v)�R�~�b�g���Ă���ƁATOP(4,000��)��DELETE���ǂ�ǂ�x���Ȃ�
rem TOP(4,000��)�����𒴂��͂��߁A39,024,000�������肩��5���ȏォ����A���̂��Ƃ͂ǂ�ǂ�x���Ȃ�
rem 3�������Ă݂�(78,130,597��3��26,043,532.33333)
rem�y1��ځz26,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F����(����ŃC���f�b�N�X�폜�O������)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F����(���񂾂���)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F���Ȃ�(�C���f�b�N�X�Ȃ�����)
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,26000000,160000,'00:00',0,'9999','1','0','1','0','0'" >> %fileNameLog%  2>&1
rem�y2��ځz26,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F���Ȃ�(�r��������)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F���Ȃ�(�C���f�b�N�X�Ȃ�����)
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,26000000,160000,'00:00',0,'9999','0','0','0','0','0'" >> %fileNameLog%  2>&1
rem�y3��ځz27,000,000���폜(�[�����܂߂đS������)
rem      �J�n���Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �I�����Ώۃ��R�[�h�J�E���g�F����(�C���f�b�N�X���邩��)
rem      �C���f�b�N�X�폜�����F���Ȃ�(�r��������)
rem      �C���f�b�N�X�쐬�����F����(�����������)
rem      ���v���擾�����F����(�����������)
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,27000000,160000,'00:00',0,'9999','0','1','0','1','1'" >> %fileNameLog%  2>&1



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


