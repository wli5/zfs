dnl #
dnl # Detect QAT related configurations.
dnl #
dnl # If configuring --enabled-qat and --with-qat=PATH, HAVE_QAT would be
dnl # defined for C code, ICP_ROOT would be defined for Makefile,
dnl # CONFIG_KERNEL_QAT_TRUE would be defined for Makefile.in
dnl #
AC_DEFUN([ZFS_AC_KERNEL_QAT], [

	AC_MSG_CHECKING([whether QAT acceleration is enabled])
	AC_ARG_ENABLE([qat],
		[AS_HELP_STRING([--enable-qat],
		[Enable QAT acceleration])],
		[],
		[enable_qat=no])
	AC_MSG_RESULT([$enable_qat])

	AS_IF([test "x$enable_qat" = xyes],
	[
		AC_MSG_CHECKING([whether qat module is installed])

		dnl #
		dnl # Identify whether qat driver is installed.
		dnl #
		qat_install_check=`ls /lib/modules/$kernsrcver/kernel/drivers/icp_qa_al.ko > /dev/null; echo $?`
		AS_IF([test "x$qat_install_check" = x0],
		[
			AC_DEFINE(HAVE_QAT, 1,
				[qat is enabled and existed])
			AC_MSG_RESULT([yes])
		],
		[
			AC_MSG_ERROR([qat driver is not installed. Please install qat driver first or bypass qat.])
		])

		dnl #
		dnl # Assign path to qat source folder.
		dnl #
		AC_ARG_WITH([qat],
			AS_HELP_STRING([--with-qat=PATH],
			[Path containing qat source directory]),
			[qatsrc="$withval"])
		AC_MSG_CHECKING([qat source directory])
		AS_IF([ test ! -d "$qatsrc/quickassist"], [
			AC_MSG_ERROR([
	*** Directory $qatsrc/quickassist doesn't exist.
	*** Please specify a location of the qat source with option
	*** '--with-qat=PATH'.])
		])
		AC_MSG_RESULT([$qatsrc/quickassist exists])
		ICP_ROOT=${qatsrc}
		AC_SUBST(ICP_ROOT)

	],
	[])

	AM_CONDITIONAL(CONFIG_KERNEL_QAT, [test "x$enable_qat" = xyes])

])
