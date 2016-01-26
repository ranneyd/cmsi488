use strict;

#
# Microsyntax:
# Word:     \w+
# Space:    \W+
# 
# Macrosyntax:
# Tree:     Node
# Node:     Block | Word
# Block:    \{Word, \[Node (, Node)*\]\}
#

sub node{
    my ($string) = @_;
    my $label;
    # Block
    if($string =~ m/^\{.*\}$/){
        
    }
    # Word
    else if($string =~ m/^\w+$/){

    }
    else{
        print "Syntax error near " . substr($string, 5) . "...";
    }

    print $string;
}

sub main{
    print "Enter an expression: ";
    my $exp = '';
    my $buff;
    # Loop over lines of input until only a newline is entered
    while(($buff = <>) =~ /^[^\n]+$/){
        chomp($buff);
        $buff =~ s/\W+/ /g;
        $exp = $exp . $buff . " "; 
    }

    print $exp ."\n";
    node($exp);
}


main();