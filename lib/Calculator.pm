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

    method total {
        [+] @.stack;
    }

    method clear {
        @.stack.splice;
    }

}

