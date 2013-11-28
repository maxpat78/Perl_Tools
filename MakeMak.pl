# Generatore di Makefile e DSP per Microsoft Visual Studio 6.0

# TODO:
# - Visual Studio: generare anche il DSW?
# - perfezionare findname per altri tipi di inserimento
# - Generare makefile anche per WMAKE

sub cerr { print STDERR for (@_); }

# Variabili globali
$targetname = 'pippo'; $ext = '.exe';
$recursive = 0;
$DSP = 0;
$Emit = 0;
$outfile = 'Makefile';
@excludes;
@loci;
@sorgenti; @sorgenti2;
%oggetti; $duplo = 0;

# Dichiarazione di un file sorgente nel Makefile
$Source = << 'EOS';
SOURCE="MYSRCPATHNAME"
"$(INTDIR)\MYOBJNAME" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ)THINGSTOINSERT$(SOURCE)

EOS


# Dichiarazione di un file sorgente nel DSP
$DSPsrc = << 'EOS';
# Begin Source File

SOURCE=MYSRCPATHNAME
# End Source File
EOS


# Modello di progetto per Visual Studio 98 (V6 DSP)
$DSPfile = << 'EOD';
# Microsoft Developer Studio Project File - Name="STRMYTARGETNAME" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=STRMYTARGETNAME - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "STRMYTARGETNAME.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "STRMYTARGETNAME.mak" CFG="STRMYTARGETNAME - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "STRMYTARGETNAME - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "STRMYTARGETNAME - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "STRMYTARGETNAME - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /G5 /MT /w /W0 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD BASE RSC /l 0x410 /d "NDEBUG"
# ADD RSC /l 0x410 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 shlwapi.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /pdb:none /machine:I386

!ELSEIF  "$(CFG)" == "STRMYTARGETNAME - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD BASE RSC /l 0x410 /d "_DEBUG"
# ADD RSC /l 0x410 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 shlwapi.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# SUBTRACT LINK32 /pdb:none

!ENDIF 

# Begin Target

# Name "STRMYTARGETNAME - Win32 Release"
# Name "STRMYTARGETNAME - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
STRMYSRCTOCOMPILE
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# End Group

# End Target
# End Project
EOD


# Modello di Makefile per NMAKE
$Makefile = << 'EOM';
# Perl Generated NMAKE File for Microsoft Visual Studio 6.0 - PLEASE EDIT!
!IF "$(CFG)" == ""
CFG=release
!MESSAGE Nessuna configurazione indicata. Si assume $(CFG).
!ENDIF 

!IF "$(CFG)" != "release" && "$(CFG)" != "debug"
!MESSAGE Configuration non valida: "$(CFG)".
!MESSAGE Indicare la configurazione sulla riga di comando nel modo
!MESSAGE seguente:
!MESSAGE 
!MESSAGE NMAKE /f "makefile" CFG="release"
!MESSAGE 
!MESSAGE Le scelte possibili sono:
!MESSAGE 
!MESSAGE "release" 
!MESSAGE "debug"
!MESSAGE 
!ERROR Configurazione specificata non valida.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF

#
# IMPOSTAZIONI PER LA CONFIGURAZIONE RELEASE
#
!IF  "$(CFG)" == "release"

OUTDIR=.\Release
INTDIR=.\Release

MY_CFLAGS=/MD /w /W0 /G6f /O2
MY_DEFINES=/D "HAVE_CONFIG_H"
MY_INCLUDES=/I "."

# Begin Custom Macros
OutDir=.\Release
# End Custom Macros


ALL : "$(OUTDIR)\STRMYTARGETNAMESTRMYEXT"


CLEAN :
STRMYOBJTOCLEAN

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /c /Fp"$(INTDIR)\STRMYTARGETNAME.pch" /YX /Fo"$(INTDIR)\\\\" /Fd"$(INTDIR)\\\\" /FD /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" $(MY_DEFINES) $(MY_INCLUDES) $(MY_CFLAGS)

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
LINK32=link.exe
LINK32_FLAGS=setargv.obj binmode.obj kernel32.lib user32.lib gdi32.lib comdlg32.lib advapi32.lib shell32.lib /nologo /subsystem:console /pdb:none /machine:I386 /out:"$(OUTDIR)\STRMYTARGETNAMESTRMYEXT" /opt:nowin98
LINK32_OBJS=STRMYOBJTOLINK

"$(OUTDIR)\STRMYTARGETNAMESTRMYEXT" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
STRMYLINKCOMMAND

!ELSEIF  "$(CFG)" == "debug"

#
# IMPOSTAZIONI PER LA CONFIGURAZIONE DEBUG
#
OUTDIR=.\Debug
INTDIR=.\Debug

MY_CFLAGS=
MY_DEFINES=/D "HAVE_CONFIG_H"
MY_INCLUDES=/I "."

# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

ALL : "$(OUTDIR)\STRMYTARGETNAMESTRMYEXT"


CLEAN :
STRMYOBJTOCLEAN
	-@erase "$(OUTDIR)\vc60.idb"
	-@erase "$(OUTDIR)\vc60.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MLd /W3 /Gm /GX /ZI /Od $(MY_INCLUDES) /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" $(MY_DEFINES) /Fp"$(INTDIR)\STRMYTARGETNAME.pch" /YX /Fo"$(INTDIR)\\\\" /Fd"$(INTDIR)\\\\" /FD /GZ /c

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

RSC=rc.exe
LINK32=link.exe
LINK32_FLAGS=setargv.obj binmode.obj kernel32.lib user32.lib gdi32.lib comdlg32.lib advapi32.lib shell32.lib /nologo /subsystem:console /incremental:yes /pdb:"$(OUTDIR)\STRMYTARGETNAME.pdb" /debug /machine:I386 /out:"$(OUTDIR)\STRMYTARGETNAMESTRMYEXT" /pdbtype:sept 
LINK32_OBJS=STRMYOBJTOLINK

"$(OUTDIR)\STRMYTARGETNAMESTRMYEXT" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
STRMYLINKCOMMAND
!ENDIF 


!IF "$(CFG)" == "release" || "$(CFG)" == "debug"

STRMYSRCTOCOMPILE

!ENDIF

EOM


#
# Funzioni
#

sub findname {
 s/(\.c(as|c|pp)?)$/.obj/i || s/\.rc$/.res/i || s/\.asm$/.obj/i;
 my $i = rindex($_,'\\');
 my $n = $i == -1? $_ : substr($_,++$i);
 my $seen=0;
 if ($oggetti{$n}) {
  $seen = 1;
  do { $n2=$n; substr($n2,-4,0)=$duplo++; } while ($oggetti{$n2});
  $n = $n2;
 }
 $oggetti{$n} = 1;
 return $n, $seen;
}

sub srctocompile {
# Notare: $Source Š un modello, quindi non va alterato, ma copiato!
 my $c, $f, $s, $repl;
 undef %oggetti; $duplo=0; # azzera il conteggio dei duplicati prima di usare findname
 for (@sorgenti) {
  $repl = " ";
  tr:/:\\:;
  ($c = $Source) =~ s/MYSRCPATHNAME/$_/;
  ($f,$seen) = (findname);
  $c =~ s/MYOBJNAME/$f/;
# Bisognerebbe estendere le possibilit… di sostituzione (ad esempio, -Tc)
  $repl .= '-Fo"$(INTDIR)\\'.$f.'" ' if ($seen);
  $c =~ s/THINGSTOINSERT/$repl/;
  $s .= $c;
 }
 $s;
}

sub DSPsrctocompile {
 my $c, $q;
 for (@sorgenti2) {
  tr:/:\\:;
  ($c = $DSPsrc) =~ s/MYSRCPATHNAME/$_/;
  $q .= $c;
 }
 $q;
}

sub objtolink {
# Anche qui si modifica globalmente, cambiando estensione
 my $s;
 undef %oggetti; $duplo=0; # azzera il conteggio dei duplicati prima di usare findname
 for (@sorgenti) {
  $s .= '"$(INTDIR)\\'.(findname)[0]."\" \\\n";
 }
 substr($s,0,-3);
}

sub objtoclean {
 my $s;
 undef %oggetti; $duplo=0; # azzera il conteggio dei duplicati prima di usare findname
 for (@sorgenti) {
  $s .= "\t-\@erase \"\$(INTDIR)\\".(findname)[0]."\"\n";
 }
 substr($s,0,-1);
}

sub mex {
#
# Individua i file con le estensioni desiderate (.c .cas .cc .cpp .rc .asm)
# $_, implicito in tutti i test, Š (e dev'essere) stato assegnato prima:
# infatti, la funzione riceve come paraemetro @_ (cioŠ $_[0],$_[1],...$[n])!
#
 /(\.c(as|c|pp)?)$/i ||
 /\.rc$/i ||
 /\.asm$/i;
}

sub cerca {
#
# Cerca in una o pi— cartelle e crea una lista globale di @sorgenti
# Notare la presenza implicita di $_ nei cicli for, in glob, nel test -d e
# in if mex... $_ contiene di volta in volta il valore che interessa, anche
# nella richiamata funzione mex
#
 for (@_) {
  for (glob $_."/*") {
   if ($recursive && -d) {
    cerca ($_);
    next;
   }
  push @sorgenti, $_ if mex;
  }
 }
}


sub leggi {
# Legge una lista di sorgenti da file o STDIN
 my $f;
 $arg = shift @ARGV;
 open IF, $arg;
 $f = ($arg eq '-')? STDIN:IF;
 warn "Impossibile leggere l'elenco dei sorgenti da $arg\n" unless -e $arg;
 while (<$f>) {
  chomp;
  push @sorgenti, $_ if mex;
 }
}


# Esamina i parametri sulla riga di comando (vedi search.pl)
sub check_args
{
 while (@ARGV && $ARGV[0] =~ m/^-/)
 {
  $arg = shift(@ARGV);

  if ($arg eq '-help' || $arg eq '-h') {
   print <<INLINE_LITERAL_TEXT;
usa: $0 [opzioni] [sorgenti ...]

OPZIONI:
  -h
  -help      questo aiuto
  -d         crea anche il DSP per Visual Studio 98
  -e         emette l'elenco dei sorgenti su STDOUT
  -f file    nome del makefile da creare (se no: 'Makefile')
  -i file|-  legge un elenco di sorgenti da STDIN (-) o dal file
  -n nome    nome del modulo da costruire (se no: 'pippo.exe')
  -p DIR     cerca nella cartella DIR   
  -r         cerca in tutte le cartelle contenute in quelle indicate
  -x regex   esclude uno o pi— file secondo l'espressione indicata

INLINE_LITERAL_TEXT
   exit(0);
  }
  $DSP=1,               next if $arg eq '-d';
  $Emit=1,              next if $arg eq '-e';
  $recursive=1,         next if $arg eq '-r';
  &leggi,               next if $arg eq '-i';   ## dump this program

  if ($arg =~ m/^-f$/) {
   $! = 2, die qq/$0: occorre indicare un nome di file dopo -$arg.\n/ unless @ARGV;
   $outfile = shift @ARGV;
   next;
  }

  if ($arg =~ m/^-n$/) {
   $! = 2, die qq/$0: occorre indicare un nome di file dopo -$arg.\n/ unless @ARGV;
   ($targetname,$ext) = split( /\./,shift(@ARGV) );
   $ext = ".".$ext;
   next;
  }

  if ($arg =~ m/^-x$/) {
   $! = 2, die qq/$0: occorre fornire un'espressione con -$arg\n/ unless @ARGV;
   push @excludes, shift @ARGV;
   next;
  }

  if ($arg =~ m/^-p$/) {
   $! = 2, die qq/$0: occorre indicare una cartella con -$arg.\n/ unless @ARGV;
   $s = shift @ARGV;
   $! = 2, warn( qq/$0: la cartella "$s" non esiste.\n/), next unless -e $s;
   $! = 2, warn( qq/$0: "$s" non Š una cartella.\n/), next unless -d _;
   push@loci, $s;
   next;
  }

  $! = 2, die "$0: argomento ignoto [$arg]\n";
 }
}

check_args;
die "$0: nessuna cartella da esaminare.\n" if ($#loci < 0 && !$#sorgenti);
cerca @loci;
die "$0: nessun sorgente da compilare.\n" if $#sorgenti < 0;
sort @sorgenti;
if (@excludes) {
 for (@excludes) {
# Questo sembra (per ora) l'unico modo di usare la RE nella $scalar...
  my $R = qr($_)i;
  @sorgenti = grep !/$R/,@sorgenti;
 }
}
if ($Emit) {
 print "$_\n" for (@sorgenti);
 exit 0; 
}

# Clona la lista, poich‚ all'eventuale DSP ne serve una intonsa
@sorgenti2 = @sorgenti;

$Makefile =~ s/STRMYTARGETNAME/$targetname/gm;
$Makefile =~ s/STRMYEXT/$ext/gm;
$s = srctocompile; $Makefile =~ s/STRMYSRCTOCOMPILE/$s/gm;
$s = objtoclean; $Makefile =~ s/STRMYOBJTOCLEAN/$s/gm;
$s = objtolink; $Makefile =~ s/STRMYOBJTOLINK/$s/gm;

$ext = lc $ext;

if ($ext eq ".exe") {
 $lnkcmd = << 'EOL';
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
EOL
} elsif ($ext eq ".dll") {
 $lnkcmd = << 'EOL';
    $(LINK32) -dll @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
EOL
} elsif ($ext eq ".lib") {
 $lnkcmd = << 'EOL';
    $(LINK32) -lib @<<
  $(LINK32_OBJS)
<<
EOL
} else {
 $lnkcmd = << 'EOL';
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<
EOL
}

$Makefile =~ s/STRMYLINKCOMMAND/$lnkcmd/gm;

open OF, ">$outfile" or die qq:Impossibile creare il makefile "$outfile!\n":;
print OF $Makefile;

if ($DSP) {
 $DSPfile =~ s/STRMYTARGETNAME/$targetname/gm;
 $s = DSPsrctocompile; $DSPfile =~ s/STRMYSRCTOCOMPILE/$s/gm;
 open OF, ">$targetname.dsp" or die qq:Impossibile creare il progetto "$targetname.dsp!\n":;
 print OF $DSPfile;
}
