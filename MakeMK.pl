# Generatore di Makefile per Watcom WMAKE

# TODO:
# - perfezionare findname per altri tipi di inserimento

sub cerr { print STDERR for (@_); }

# Variabili globali
$targetname = 'pippo'; $ext = '.exe';
$recursive = 0;
$Emit = 0;
$outfile = 'Makefile';
@excludes;
@loci;
@sorgenti; @sorgenti2;
%oggetti; $duplo = 0;

# Dichiarazione di un file sorgente nel Makefile
$Source = << 'EOS';
$odir\MYOBJNAME : MYSRCPATHNAME .AUTODEPEND
 *$wcc $copt $incl -fo=$odir\MYOBJNAME&
 MYSRCPATHNAME

EOS


# Modello di Makefile per WMAKE
$Makefile = << 'EOM';
# Macro globali: modificare qui, se serve
wcc  = wcc386 -zq
copt = -6 -fp6 -ei -oneatxhl+ -d0 -zld -bt=dos
incl = -I.
odir = wat_dos

project : $odir STRMYTARGETNAMESTRMYEXT .SYMBOLIC

$odir : 
 md $odir

clean : .SYMBOLIC
 del $odir\*.obj
 del $odir\*.err
 del STRMYTARGETNAMESTRMYEXT
 del STRMYTARGETNAME.lk1
 del STRMYTARGETNAME.map
 rd $odir

STRMYSRCTOCOMPILE

STRMYTARGETNAMESTRMYEXT : &
STRMYOBJTOLINK
.AUTODEPEND
 @%write STRMYTARGETNAME.lk1 n STRMYTARGETNAME
 @%append STRMYTARGETNAME.lk1 f &
STRMYLKOBJS
 @%append STRMYTARGETNAME.lk1 
 *wlink SYS causeway OP st=128K OP c OP q @STRMYTARGETNAME.lk1

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
  ($c = $Source) =~ s/MYSRCPATHNAME/$_/gm;
  ($f,$seen) = (findname);
  $c =~ s/MYOBJNAME/$f/gm;
# Bisognerebbe estendere le possibilit… di sostituzione (ad esempio, -Tc)
  $repl .= '-fo"$(INTDIR)\\'.$f.'" ' if ($seen);
  $c =~ s/THINGSTOINSERT/$repl/;
  $s .= $c;
 }
 $s;
}


sub objtolink {
# Anche qui si modifica globalmente, cambiando estensione
 my $s;
 undef %oggetti; $duplo=0; # azzera il conteggio dei duplicati prima di usare findname
 for (@sorgenti) {
  $s .= '$odir\\'.(findname)[0]." &\n";
 }
 substr($s,0,-3);
}

sub objtolink2 {
# Anche qui si modifica globalmente, cambiando estensione
 my $s;
 undef %oggetti; $duplo=0; # azzera il conteggio dei duplicati prima di usare findname
 for (@sorgenti) {
  $s .= '$odir\\'.substr((findname)[0],0,-4).",&\n";
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
$s = objtolink2; $Makefile =~ s/STRMYLKOBJS/$s/gm;

open OF, ">$outfile" or die qq:Impossibile creare il makefile "$outfile!\n":;
print OF $Makefile;
