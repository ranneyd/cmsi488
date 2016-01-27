use strict;
use integer;

sub node;
sub block;

sub draw;
sub drawNode;

sub height;

sub error;
sub printArray;
sub main;


#
# Microsyntax:
# Word:     [^{}, ]+|["'].+?["']
# Space:    \s+
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
    
    # Word
    if($string =~ m/(^[^{}, ]+)|(['"].+?['"])$/){
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

    my $subtree = [];

    my $bracketCount = 0;
    my $quote = 0;
    my $item = "";

    # width of children. Every child is one space apart and has a width of 4 + label content
    my $width = 0;

    # gonna loop through and tokenize. Tried with Regex but matching brackets  isn't happy
    foreach my $char (split("", $inside)) {
        if($char eq "'" | $char eq '"'){
            if($quote){
                push @{$subtree}, $item;
                $item = "";
                $quote = 0;
            }
            else{
                if($item ne ""){
                    return error $inside,
                        "You have letters then a '. Forget a comma?";
                }
                $quote = 1;
            }
        }
        elsif($char eq "," && !$bracketCount){
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
            $item .= $char;
            if(--$bracketCount == 0){
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
            if($char =~ m/\s/ && !$bracketCount && !$quote) {
                # whitespace without a comma is a no-go
                if($item ne ""){
                    return error $inside, 
                        "Sketchy whitespace error. Did you forget a comma?";
                }   
            }
            # just a letter or inside brackets
            else{
                $item .= $char;
            }
        }
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
    my ($treeref, $height) = @_;

    my @output = ();

    # Gotta give it a tree reference, an output reference, level of our output (0 initially) and the
    # height of our tree
    drawNode $treeref, \@output, 0, $height;

    foreach my $line(@output){
        print "$line\n";
    }
}

sub drawNode{
    my ($treeref, $outputref, $level, $height) = @_;
    
    # Block
    if(ref($treeref) eq "ARRAY"){

        my $label = $treeref->[0];
        my $width = $treeref->[-1];

        my $labelWidth = 4 + length $label;
        my $leftMargin = ($width - $labelWidth) / 2;
        my $rightMargin = $width - $labelWidth - $leftMargin;

        $outputref->[$level++] .= " " x $leftMargin . "-" x $labelWidth . " " x ($rightMargin + 1);
        $outputref->[$level++] .= " "  x $leftMargin . "| $label |" . " " x ($rightMargin + 1);
        $outputref->[$level++] .= " "  x $leftMargin . "-" x $labelWidth . " " x ($rightMargin + 1);
        $outputref->[$level++] .= " " x ($leftMargin + $labelWidth / 2) . "|" . (" " x ($labelWidth - $labelWidth/2 + $rightMargin));
        if(@{$treeref} > 3) {
            $outputref->[$level++] .= "  " . "-" x ($width - 4) . "   ";
        }

        for(my $i = 1; $i < @{$treeref} -1; ++$i){

            drawNode($treeref->[$i], $outputref, $level, $height - 1);
        }
    }
    # Word
    else{

        my $labelWidth = 4 + length $treeref;

        my $labelMod = 0;
        $outputref->[$level + $labelMod++] .= "-" x $labelWidth . " ";
        $outputref->[$level + $labelMod++] .= "| $treeref |" . " ";
        $outputref->[$level + $labelMod++] .= "-" x $labelWidth . " ";
        while (--$height){
            $outputref->[$level + $labelMod++] .= " " x ($labelWidth+1);
            $outputref->[$level + $labelMod++] .= " " x ($labelWidth+1);
            $outputref->[$level + $labelMod++] .= " " x ($labelWidth+1);
            $outputref->[$level + $labelMod++] .= " " x ($labelWidth+1);
            $outputref->[$level + $labelMod++] .= " " x ($labelWidth+1);
        }
    }
}

sub height{
    my ($tree) = @_;

    my $height = 0;

    # Has Children
    if(ref($tree) eq "ARRAY") {
        foreach my $child (@$tree) {
            my $newHeight = 1 + height $child;

            # http://www.perlmonks.org/?node_id=406883
            # Sets $height to max of $height and $newHeight

            # We make an array with our first value at index 0 and our second at index 1. Then we
            # get the element at a position computed from the boolean expression, which works fine
            # since our indexes are 0 and 1. Very cool. Very elegant
            $height = ($height, $newHeight)[$height <= $newHeight];
        }

    }
    return $height;
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
    if(node( $exp, $tree ) != -1) {
        # I could have done height in node, but it's too complicated already.
        draw $tree->[0], height $tree;
    }
}

main();