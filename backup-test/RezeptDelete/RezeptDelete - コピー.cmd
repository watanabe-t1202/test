rem pause�Ƃ��̖₢���킹�n�̓X�P�W���[���N������ꍇ�͑S�ăR�����g�A�E�g���Ȃ��Ɨ��Ŏ~�܂����܂܂ɂȂ�
rem @echo #
rem @echo #################################################################
rem @echo #                                                               #
rem @echo #   �ق�Ƃ��Ɏ��s���܂����I�H �L�����Z���́~�ŕ��Ă�������   #
rem @echo #                                                               #
rem @echo #################################################################
rem @echo #
rem pause

rem sqlcmd�ڑ����
rem -S (server), -d (dbname), -U (login_id), -P (password)
set sqlcmd=sqlcmd -S CL115616205A -d kyusyo4 -U kyusyo -P kyusyo

rem �폜---------------------------------------------------------------
rem �o�͂���t�@�C������_log
set fileNameLog=c:\backup-test\RezeptDelete\RezeptDelete.log


rem   @DelStartYYYYMMDD NVARCHAR(8)  --�폜�J�n �捞��            �FYYYYMMDD
rem   @DelEndYYYYMMDD   NVARCHAR(8)  --�폜�I�� �捞��            �FYYYYMMDD
rem   @DelYoukyuCnt     int          --����폜����������         �F
rem   @DelCount         int          --�P��̍폜���� �@�@        �F
rem   @CommitCnt        int          --�R�~�b�g����������         �F@DelPerCnt�̌�����DELETE���[�v���Ă���B�폜�������w�茏���ɒB������R�~�b�g����B�R�~�b�g���ɍ폜�����̓��Z�b�g����B
rem   @CommitWaitFor    NVARCHAR(8)  --�R�~�b�g��̑҂�����       �F�R�~�b�g��ɏ������x�~���鎞�Ԃ�ݒ肷��(hh:mm:ss)�B�w�肵�Ȃ��ꍇ��'00:00:00'�Ƃ���B
rem   @ReStatusCnt      int          --���v���Ď擾�R�~�b�g�� �F�R�~�b�g�񐔖���T_REZEPT�̓��v�����擾�ł���B�R�~�b�g�񐔂��w��񐔂ɒB�����瓝�v���擾����B���v���擾��̓R�~�b�g�񐔂����Z�b�g����B
rem   @LimitYYYYMMDD    NVARCHAR(10) --�������f��                 �F�폜���[�v�𒆒f����N�������w��ł���B�w�肵�Ȃ��ꍇ��'yyyy-MM-dd'�Ƃ���B
rem   @LimitHHmm        NVARCHAR(5)  --�������f����               �F�폜���[�v�𒆒f���鎞�����w��ł���B�w�肵�Ȃ��ꍇ��'9999'�Ƃ���B
rem   @StartRecCnt      NVARCHAR(1)  --�J�n���Ώۃ��R�[�h�J�E���g �F�ŏ��ɍ폜�Ώۂ̌������擾���邩('0':�擾���Ȃ�/'1':�擾����)
rem   @EndRecCnt        NVARCHAR(1)  --�I�����Ώۃ��R�[�h�J�E���g �F�Ō�ɍ폜�Ώۂ̌������擾���邩('0':�擾���Ȃ�/'1':�擾����)
rem   @IndexDel         NVARCHAR(1)  --�C���f�b�N�X�폜����       �F�C���f�b�N�X���폜���邩('0':�폜���Ȃ�/'1':�폜����) **�댯�ȏ����Ȃ̂ł��̉ӏ����ĉ���**
rem   @IndexCre         NVARCHAR(1)  --�C���f�b�N�X�쐬����       �F�C���f�b�N�X���쐬���邩('0':�쐬���Ȃ�/'1':�쐬����) **�댯�ȏ����Ȃ̂ł��̉ӏ����ĉ���**
rem   @Stat             NVARCHAR(1)  --���v���擾����           �F�Ō�ɓ��v�����擾���邩('0':�擾���Ȃ�/'1':�S�̂̓��v�����擾����/'2':T_REZEPT�̂ݓ��v�����擾����)
rem   @Comp             NVARCHAR(1)  --DB���k                     �F�Ō�Ƀ��O�t�@�C���A�f�[�^�t�@�C�������k���邩('0':���k���Ȃ�/'1':���k����)
rem   @Check            NVARCHAR(1)  --DB�j���`�F�b�N             �F�Ō�ɔj���`�F�b�N�����邩('0':���Ȃ�/'1':����)


%sqlcmd% -Q "EXEC RezeptDelete 20150101,20151231,500000,500,500,'00:00:30',0,'2025-12-31','9999','1','1','0','0','1','0','1'" >> %fileNameLog%  2>&1





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


