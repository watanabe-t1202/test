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
set fileNameLog=c:\temp\deldellog2.log
rem sqlcmd�ڑ����
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo2 -U kyusyo2 -P kyusyo2


rem �T�[�r�X�N��(�O�̂���)
net start "SQL Server (MSSQLSERVER)"


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
rem 3�������Ă݂�(78,130,597�|39,000,000�|39,000,000��130,597)
rem�y2��ځz39,000,000���폜
rem      �J�n���Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �I�����Ώۃ��R�[�h�J�E���g�F���Ȃ�(�C���f�b�N�X�Ȃ�����)
rem      �C���f�b�N�X�폜�����F���Ȃ�(�r��������)
rem      �C���f�b�N�X�쐬�����F���Ȃ�(�����͂��邩��)
rem      ���v���擾�����F����(UPDATE STATISTICS t_rezept)
rem      �������f�����F�\�肩�炢����20:30�ɂ͏I����ĂȂ��ƍ���
%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,39000000,160000,'00:00',0,'2030','0','0','0','0','2'" >> %fileNameLog%  2>&1

rem �T�[�r�X�ċN��
rem ������������_��
net stop "SQL Server (MSSQLSERVER)"
net start "SQL Server (MSSQLSERVER)"


rem sqlcmd���s���ʂŏ����𕪊�
rem 0:����I�� ����ȊO:�ُ�I��
if %errorlevel% equ 0 (
 echo ����I�����܂����B>> %fileNameLog%


) else (
 echo �ُ�I�����܂����B>> %fileNameLog%


)


rem -------�����L�ڂ����܂�------

echo �v���O�������I�����܂����B


rem pause
exit


