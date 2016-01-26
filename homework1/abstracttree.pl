use strict;
use integer;

sub node;
sub block;

sub draw;

sub error;
sub printArray;
sub main;

#
# Microsyntax:
# Word:     \w+
# Space:    \W+
# 
# Macrosyntax:
# Tree:     Node
# Node:     Block | Word
# Block:    \{Word, Node, \[Node (, Node)*\]\}
#

sub node{
    my ( $string, $tree ) = @_;

    # Removes trailing or leading whitespace
    $string =~ s/^\s+|\s+$//g;

    #print "|Node time\n";
    #print "|".$string."\n";
    
    # Word
    if($string =~ m/^\w+$/){
        push @{$tree}, $string;
    }
    # Block
    elsif($string =~ m/^\{(.*)\}$/){
        if(block($1, $tree) == -1){
            return -1;
        }
    }
    else{
        return error $string,
            "Expected either a word or a block. Got " . $string;
    }

    return 0;

}
sub block{
    my ($inside, $tree) = @_;

    #print "|found a block\n";
    #print "|".$inside . "\n";

    my $subtree = [];

    my $bracketCount = 0;
    my $item = "";

    # width of children. Every child is one space apart and has a width of 4 +
    # label content
    my $width = 0;

    # gonna loop through and tokenize. Tried with Regex but matching
    # brackets  isn't happy
    foreach my $char (split("", $inside)) {
        #print "----\n";
        #print "|char " . $char ."\n";
        #print "|item ". $item . "\n";
        #print "|bracketCount " . $bracketCount . "\n";
        if($char eq "," && !$bracketCount){
            #print "|comma time\n";
            # In case we had a sub-block followed by a comma.
            if($item ne ""){
                # if we have an empty array, this thing is the label
                if(@{$subtree}){
                    $width += 5 + length $item;
                }
                push @{$subtree}, $item;
                $item = "";  
            }

        }
        elsif($char eq "{"){
            #print "|open bracket time\n";
            if($item ne "" && !$bracketCount){
                return error $inside,
                    "You have letters then {. Did you forget a comma?";
            }
            else{
                $bracketCount++;
                $item .= $char;
            }
        }
        elsif($char eq "}"){
            #print "|closed bracket time\n";
            $item .= $char;
            if(--$bracketCount == 0){
                #print "|Uh oh, time to wrap this show up\n";
                if(node($item, $subtree) == -1){
                    return -1;
                }
                # get the last element of the last thing in the list
                $width += 1 + $subtree->[-1]->[-1];

                $item = ""; 
            }
        }
        else{
            # whitespace
            if($char =~ m/\s/ && !$bracketCount) {
                # whitespace without a comma is a no-go
                if($item ne ""){
                    return error $inside, 
                        "Sketchy whitespace error. Did you forget a comma?";
                }   
            }
            # just a letter or inside brackets
            else{
                #print "|just a letter\n";
                $item .= $char;
            }
        }
        #print "|final " . $item . "\n";
    }

    if($bracketCount != 0){
        return error $inside,
            "Mismatched brackets. Make sure every open has a close";
    }
    if($item ne ""){
        $width += 5 + length $item;

        push @{$subtree}, $item;
    }
    # returns empty string when not a reference, or a scalar in this case
    if(ref($subtree->[0]) ne "") {
        return error $inside,
            "Remember that the first element of a block must be a word";
    }

    # add width to end, remove trailing space
    push @{$subtree}, --$width;

    push @{$tree}, $subtree;
    return 0;
}


sub draw{
    my ($treeref) = @_;
    my @tree = @{$treeref};

    my $label = shift @tree;
    my $width = pop @tree;

    my $labelWidth = 4 + length $label;
    my $leftMargin = ($width - $labelWidth) / 2;

    # my $width = length( $label ) + 4;

    # print "-" x $width . "\n";
    # print "| " . $label . " |\n";
    # print "-" x $width . "\n";
    # print " " x ($width/2) . "|\n";

}

sub error{
    my ( $string, $msg ) = @_;
    print "Syntax error near '" . substr( $string, 0, 10 ) . "...'\n";
    print $msg . "\n";
    return -1;
}

sub printArray{
    my ( $arrayRef ) = @_;

    # Start it off so we can put the comma in the right place
    print "[";
    for (my $i = 0; $i < @{$arrayRef}; $i++){
        
        my $elem = $arrayRef->[$i];

        # if it's an array, we recursion it up
        if ( ref($elem) eq "ARRAY" ) {
            printArray $elem;
        }
        else{
            print $arrayRef->[$i];
        }

        # add a space unless it's the last element
        if( $i + 1 < @{$arrayRef} ){
            print ", ";
        }
    }
    print "]";
}

sub main{
    # print "Enter an expression: ";

    # my $exp = '';
    # my $buff;

    # # Loop over lines of input until only a newline is entered
    # while( ($buff = <>) =~ /^[^\n]+$/ ){
    #     # Replace all contiguous whitespace with a single space
    #     $buff =~ s/\s+/ /g;

    #     $exp .= $buff . " "; 
    # }

    my $exp = '{foo, {bar, baz, {abc, def}, asdf}}';

    # This data structure will be our tree
    my $tree = [];

    # Our macrosyntax states that our tree begins with one node
    if(node( $exp, $tree ) != -1) {
        printArray $tree;
    }
}

main();


#{foo, foobar, {bar, baz, {abc, def}, asdf}}