## A boring RPN calculator class.

class Calculator {
    has @.stack;

    method add {
        given @.stack {
            .push( .pop + .pop );
        }
    }

    method subtract {
        given @.stack {
            .push( .pop R- .pop );
        }
    }

    method multiply {
        given @.stack {
            .push( .pop * .pop );
        }
    }

    method divide {
        given @.stack {
            .push( .pop R/ .pop );
        }
    }

    method push (Num $number) {
        @.stack.push($number);
    }

    method total () {
        [+] @.stack;
    }

    method first (Int $i) {
        @.stack[$i];
    }

    method last (Int $i=1) {
        @.stack[*-$i];
    }

    method clear {
        @.stack.splice;
    }

}

