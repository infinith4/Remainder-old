#!/usr/bin/perl

use strict;
use warnings;

use IPC::Cmd qw[can_run run run_forked];

my $full_path = can_run('perl') or warn 'wget is not installed!';

    ### commands can be arrayrefs or strings ###
#my $cmd = $full_path."./schedule_sendmail.pl";
my $cmd = [$full_path, 'schedule_sendmail.pl'];

    ### in scalar context ###
my $buffer;
    if( scalar run( command => $cmd,
                    verbose => 0,
                    buffer  => \$buffer,
                    timeout => 20 )
    ) {
        print "fetched webpage successfully: $buffer\n";
}


    ### in list context ###
    my( $success, $error_message, $full_buf, $stdout_buf, $stderr_buf ) =
    run( command => $cmd, verbose => 0 );

if( $success ) {
    print "this is what the command printed:\n";
    print join "", @$full_buf;
}

    ### check for features
print "IPC::Open3 available: "  . IPC::Cmd->can_use_ipc_open3;
print "IPC::Run available: "    . IPC::Cmd->can_use_ipc_run;
print "Can capture buffer: "    . IPC::Cmd->can_capture_buffer;
print "\n";
    ### don't have IPC::Cmd be verbose, ie don't print to stdout or
    ### stderr when running commands -- default is '0'
$IPC::Cmd::VERBOSE = 0;


