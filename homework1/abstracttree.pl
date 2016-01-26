use strict;


sub node;

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

    # Label on the diagram
    my $label;

    # Block
    if($string =~ m/^\{(.*)\}$/){
        # print "|found a block\n";
        
        # first match should be what's in the brackets
        my $inside = $1;
        my $subtree = [];

        my $bracketCount = 0;
        my $token = "";
        # gonna loop through and tokenize. Tried with Regex but matching
        # brackets  isn't happy
        foreach $char (split("", $inside)) {
            if($char =~ m/\w/){
            }
            elsif($char eq ","){
                push @{$subtree}, $token;
                $token = "";
            }
            elsif($char =~ m/\s/){
                $token .= $char;
            }
        }

        my $label = shift $subtree;

        if(ref($label) ne "STRING") {
            error $inside;
            print "Remember that the first element of a block must be a word";
            return -1;
        }


        push @{$tree}, $child;
    }
    # Word
    elsif($string =~ m/^\w+$/){
        push @{$tree}, $string;
    }
    else{
        error $string;
        return -1;
    }

}

sub error{
    my ( $msg ) = @_;
    print "Syntax error near '" . substr( $msg, 0, 10 ) . "...'\n";
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
    print "Enter an expression: ";

    my $exp = '';
    my $buff;

    # Loop over lines of input until only a newline is entered
    while( ($buff = <>) =~ /^[^\n]+$/ ){
        # Replace all contiguous whitespace with a single space
        $buff =~ s/\s+/ /g;

        $exp .= $buff . " "; 
    }

    # This data structure will be our tree
    my $tree = [];

    # Our macrosyntax states that our tree begins with one node
    node( $exp, $tree );

    printArray $tree;
}

    # my $width = length( $label ) + 4;

    # print "-" x $width . "\n";
    # print "| " . $label . " |\n";
    # print "-" x $width . "\n";
    # print " " x ($width/2) . "|\n";


main();

