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
set fileNameLog=c:\temp\deldellogFinal.log


rem    @DelStartYYYYMMDD NVARCHAR(8) --�폜�J�n �捞��            �FYYYYMMDD
rem   ,@DelEndYYYYMMDD   NVARCHAR(8) --�폜�I�� �捞��            �FYYYYMMDD
rem   ,@DelYoukyuCnt     int         --����폜����������         �F
rem   ,@CommitCnt        int         --�R�~�b�g����������         �FTOP(4000)��DELETE���[�v���Ă���B�폜�������w�茏���ɒB������R�~�b�g����B�R�~�b�g���ɍ폜�����̓��Z�b�g����B
rem   ,@CommitWaitFor    NVARCHAR(5) --�R�~�b�g��̑҂�����(mm:ss)�F�R�~�b�g��ɏ������x�~���鎞�Ԃ�ݒ肷��B�ŏ��ݒ�1�b(00:01)
rem   ,@ReStatusCnt      int         --���v���Ď擾�R�~�b�g�� �F�R�~�b�g�񐔖���T_REZEPT�̓��v�����擾�ł���B�R�~�b�g�񐔂��w��񐔂ɒB�����瓝�v���擾����B���v���擾��̓R�~�b�g�񐔂����Z�b�g����B
rem   ,@LimitYYYYMMDD    NVARCHAR(8) --�������f��                 �F�폜���[�v�𒆒f����N�������w��ł���B�w�肵�Ȃ��ꍇ��'yyyy-MM-dd'�Ƃ���B
rem   ,@LimitHHmm        NVARCHAR(5) --�������f����               �F�폜���[�v�𒆒f���鎞�����w��ł���B�w�肵�Ȃ��ꍇ��'9999'�Ƃ���B
rem   ,@StartRecCnt      NVARCHAR(1) --�J�n���Ώۃ��R�[�h�J�E���g �F�ŏ��ɍ폜�Ώۂ̌������擾���邩('0':�擾���Ȃ�/'1':�擾����)
rem   ,@EndRecCnt        NVARCHAR(1) --�I�����Ώۃ��R�[�h�J�E���g �F�Ō�ɍ폜�Ώۂ̌������擾���邩('0':�擾���Ȃ�/'1':�擾����)
rem   ,@IndexDel         NVARCHAR(1) --�C���f�b�N�X�폜����       �F�C���f�b�N�X���폜���邩('0':�폜���Ȃ�/'1':�폜����)��Index2�͏���
rem   ,@IndexCre         NVARCHAR(1) --�C���f�b�N�X�쐬����       �F�C���f�b�N�X���쐬���邩('0':�쐬���Ȃ�/'1':�쐬����)��Index2�͏���
rem   ,@Stat             NVARCHAR(1) --���v���擾����           �F�Ō�ɓ��v�����擾���邩('0':�擾���Ȃ�/'1':�S�̂̓��v�����擾����/'2':T_REZEPT�̂ݓ��v�����擾����)
rem   ,@Comp             NVARCHAR(1) --DB���k                     �F�Ō�Ƀ��O�t�@�C���A�f�[�^�t�@�C�������k���邩('0':���k���Ȃ�/'1':���k����)
rem
rem TOP(4,000��)��DELETE���s���A160,000������(40���[�v)�R�~�b�g���Ă���ƁATOP(4,000��)��DELETE���ǂ�ǂ�x���Ȃ�
rem TOP(4,000��)�����𒴂��͂��߁A39,024,000�������肩��5���ȏォ����A���̂��Ƃ͂ǂ�ǂ�x���Ȃ�
rem 3�������Ă݂�(78,130,597�|39,000,000��39,130,597)

%sqlcmd% -Q "EXEC DelDelKun 20150101,20151231,79000000,160000,'00:00',0,'2025-01-06','0100','1','1','1','1','1','1'" >> %fileNameLog%  2>&1





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


