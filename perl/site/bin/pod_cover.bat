@rem = '--*-Perl-*--
@echo off
if "%OS%" == "Windows_NT" goto WinNT
perl -x -S "%0" %1 %2 %3 %4 %5 %6 %7 %8 %9
goto endofperl
:WinNT
perl -x -S %0 %*
if NOT "%COMSPEC%" == "%SystemRoot%\system32\cmd.exe" goto endofperl
if %errorlevel% == 9009 echo You do not have Perl in your PATH.
if errorlevel 1 goto script_failed_so_exit_with_non_zero_val 2>nul
goto endofperl
@rem ';
#!C:\strawberry\perl\bin\perl.exe -w
#line 15

# Run this to get a coverage analysis of the embedded documentation

use Pod::Coverage;
use lib 'lib';			# to test distribution inside './lib'
use strict;

print "Pod coverage analysis v1.00 (C) by Tels 2001.\n";
print "Using Pod::Coverage v$Pod::Coverage::VERSION\n\n";

print scalar localtime()," Starting analysis:\n\n";

my $covered = 0; my $uncovered; my $count = 0; my $c;
open FILE, 'MANIFEST' or die "Can't read MANIFEST: $!";
while (<FILE>)
  {
  chomp;
  my ($file) = split /[\s\t]/,$_;
  next unless $file =~ /^lib.*\.pm$/;
  $file =~ s/^lib\///;			# remove lib and .pm
  $file =~ s/\.pm$//;
  $file =~ s/\//::/g;			# / => ::
  my $rc = Pod::Coverage->new( package => $file );
  $covered += $rc->covered(); 
  $uncovered += $rc->uncovered(); 
  $count ++;
  $c = $rc->coverage() || 0; 
  $c = int($c * 10000)/100;
  print "$file has a doc coverage of $c%.\n";
  my @naked = $rc->naked();
  if (@naked > 0)
    {
    print "Uncovered routines are:\n";
    print " ",join("\n ",sort @naked),"\n";	# sort by name
						# could sort by line_num
    }
  print "\n";
  }

my $total = $covered+$uncovered;
my $average = 'unknown';
$average = int(10000*$covered/$total)/100 if $total > 0;

print "Summary:\n";
print " sub routines total    : $total\n";
print " sub routines covered  : $covered\n";
print " sub routines uncovered: $uncovered\n";
print " total coverage        : $average%\n\n";

__END__
:endofperl
