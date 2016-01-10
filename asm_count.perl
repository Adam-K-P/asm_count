#!/usr/bin/perl
#Counts the number of each asm instruction and prints out its 
#frequency (percentage and count) under each optimization level

use strict;
use warnings;

my %commands = ();

sub hash_comms {
   my $file = shift;
   my $num_comms = 0;
   my %these_commands = ();
   while (my $line = <$file>) {
      if ($line =~ ":") { next; }
      my $command;
      my $throwaway;
      ($command, $throwaway) = split (' ', $line, 2);
      if (not ($command =~ /^\./)) { #hide compiler directives
         ++$num_comms;
         if (exists $these_commands{$command}) {
            $these_commands{$command} = $these_commands{$command} + 1;
         }
         else {
            $these_commands{$command} = 1;
         }
      }
   }
   %commands = %these_commands; #lol
   return $num_comms;
}

sub print_stats {
   my $num_comms = shift;
   printf "%d total instructions\n", $num_comms;
   foreach my $key (keys %commands) {
      my $frequency = $commands{$key};
      my $percentage = $frequency / $num_comms * 100;
      printf "%10s- percentage: %3d%%      occurences: %3d\n", 
              $key, $percentage, $frequency;
   }
}

sub generate_asm {
   my $file_name = shift;
   my $optim_lvl = shift;
   my $command = "gcc -O" . $optim_lvl . " -S " . $file_name;
   system $command;
}

sub get_asm_name {
   my $file_name = shift;
   my $sfile_name;
   my $temp;
   ($sfile_name, $temp) = split (/\.c/, $file_name);
   $sfile_name = $sfile_name . ".s";
   return $sfile_name;
}

sub gen_file_stats {
   my $file_name = shift;
   my $sfile_name = get_asm_name $file_name;
   for (my $i = 0; $i <= 3; ++$i) {
      generate_asm $file_name, $i;
      my $file;
      open ($file, "<", $sfile_name) or die "error opening file";
      my $num_comms = hash_comms $file;
      printf "OPTIMIZATION LEVEL: %d\n", $i;
      print_stats $num_comms;
      printf "\n";
      close $file;
   }
}

sub main {
   for (my $i = 0; $i < scalar @ARGV; ++$i) {
      gen_file_stats $ARGV[$i];
   }
}

main ();
      
