incdir=$1
libdir=$2
ldso=$3
cat <<EOF
*libdir:
$libdir

%rename cpp_options old_cpp_options

*cpp_options:
-nostdinc -isystem $incdir -isystem include%s %(old_cpp_options)

*cc1:
%(cc1_cpu) -nostdinc -isystem $incdir -isystem include%s

*link_libgcc:
-L%(libdir) -L .%s

*libgcc:
libgcc.a%s %:if-exists(libgcc_eh.a%s)

*startfile:
%{static-pie: %(libdir)/rcrt1.o; !shared: %(libdir)/Scrt1.o} %(libdir)/crti.o crtbeginS.o%s

*endfile:
crtendS.o%s %(libdir)/crtn.o

*link:
%{static|static-pie:; :-dynamic-linker %(libdir)/libc.so} %{shared:-shared} %{static:-static} %{static-pie:-static -pie --no-dynamic-linker -z text} %{rdynamic:-export-dynamic}

*esp_link:


*esp_options:


*esp_cpp_options:


EOF
