#!/usr/bin/perl 
# Check the health of a mysql server.
use DBI;
use Log::Simplest;
use strict;
use warnings;
use File::Find;


sub check_connection {
    if (!defined $ENV{'HOST'} || !defined $ENV{'USERNAME'}) {  
        &Fatal("Couldn't find the environment variable for host or user. Dying...\n");
        exit 1;
    };

    if (!defined $ENV{'PORT'}) {
        $ENV{'PORT'} = 3306;
    };
    
    my $dbh;
    &Log("Connecting to Database: " . $ENV{'HOST'} . "\n"); 
    $dbh = DBI->connect("DBI:mysql:host=$ENV{'HOST'};port=$ENV{'PORT'}", $ENV{'USERNAME'}, $ENV{'PASSWORD'}, 
        {'RaiseError' => 1, 'PrintError' => 1, 'HandleError' => \&handle_error}
        ) or handle_error(DBI->errstr);
    $dbh->disconnect;
    &Log("Successfully connected!");
    exit(0)    
}

sub total_files {
    my $total;
    find(sub { $total += -f }, $ENV{'LOG_DIR'});
    if ($total > 100) {
        &Log("Found more than 100 files in logs directory so deleting...");
        cleanup();
    }
    &Log("Total files found in logs directory: " . $total);
}

# Log file deletions:
sub cleanup {
    my $errors;
    while ($_ = glob('./logs/* /logs/.*')) {
    next if -d $_;
    unlink($_)
        or ++$errors, warn("Can't remove $_: $!");
        }
    exit(1) if $errors;
}

sub handle_error { 
    my $error = shift;
    &Log("Error connecting to the DB so I'm dying now!...$error\n");
    exit(1)
}

#If we want to control from within the PERL script (because I've put it in the docker container). 
#Feel free to remove this and just call "check_connection". 
#while (1) {
#    sleep $ENV{'TIMING'};
#    check_connection();
#
total_files();
check_connection();