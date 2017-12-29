#!/usr/bin/perl -w

use File::Temp;
use Getopt::Long;

#MAIN ICON SET
my @iconlist = (
    "./source/ic_stop_black_48px",                  # STOP
    "./source/ic_play_arrow_black_48px",            # PLAY
    "./source/ic_pause_black_48px",                 # PAUSE
    "./source/ic_fast_forward_black_48px",          # FAST FORWARD
    "./source/ic_fast_rewind_black_48px",           # FAST REWIND
    "./source/ic_fiber_manual_record_black_48px",   # RECORD
    "./source/ic_repeat_black_48px",                # REPEAT
    "./source/ic_repeat_one_black_48px",            # REPEAT ONE
    "./source/ic_repeat_light_grey_48px",           # REPEAT OFF
    "./source/ic_shuffle_black_48px",               # SHUFFLE
    "./source/ic_shuffle_light_grey_48px",          # SHUFFLE OFF
    "./source/ic_skip_next_black_48px",             # SKIP NEXT
    "./source/ic_skip_previous_black_48px",         # SKIP PREVIOUS
    "./source/ic_more_vert_black_48px",             # CONTEXT MENU
);


my $help;
my $source="";
my $size;
my @list = @iconlist;
my $output = "immaterial_assets";


GetOptions ( 'h|help'   => \$help,
             'o|output=s' => \$output,
             't|source=s' => \$source,
    );


if($#ARGV != 0 or $help) {
    print "usage: $0 [-o <PREFIX>] [-t <PATH>] <SIZE>\n";
    print "\n";
    print "  -h\tshow this help dialogue\n";
    print "  -o\tuse <PREFIX> for the output filename\n";
    print "\tnote: default <PREFIX> is \"playback_icons\"\n";
    print "  -t\tpath to source of immaterial assets\n";
    print "\n";
    print "  \t<SIZE> can be in the form of NN or NNxNN\n";
    print "\tnote: also used for the output filename\n";
    exit();
}


$size = $ARGV[0];


my $alphatemp = File::Temp->new(SUFFIX => ".png");
my $alphatempfname = $alphatemp->filename();
my $exporttemp = File::Temp->new(SUFFIX => ".png");
my $exporttempfname = $exporttemp->filename();
my $tempstrip = File::Temp->new(SUFFIX => ".png");
my $tempstripfname = $tempstrip->filename();
my $newoutput = "$size-$output.bmp";


if(-e $newoutput) {
    die("warning: $newoutput already exists\n");
}


print "creating $newoutput ...\n";


my $count;
$count = 0;


foreach(@list) {
    print "processing $_ ...\n";
    my $file;
    if(m/^$/) {
        my $s = $size . "x" . $size;
        `convert -size $s xc:"#ff00ff" -alpha transparent $exporttempfname`
    }
    elsif(m/\./) {
        $file = $_ . ".svg";
        `inkscape --export-png=$exporttempfname --export-width=$size --export-height=$size $file`
    }
    else {
        if ($source eq "") {
            print "Path to immaterial sources needed but not given!\n";
            exit(1);
        }
        $file = "$source/scalable/" . $_ . ".svg";
        `cp $file source/`;
    }
    if($count != 0) {
        `convert -append $tempstripfname $exporttempfname $tempstripfname`;
    }
    else {
        `convert $exporttempfname $tempstripfname`;
    }
    $count++;
}


print "completed\n\n";


print "converting result ...\n";
`convert $tempstripfname $newoutput`;
print "completed\n";