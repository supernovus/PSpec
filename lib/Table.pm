## A Cucumber-like Table class, and modifications to Array.

use MONKEY_TYPING;

augment class Array {
    method hashMap (@fields) {
        my %fields;
        for @fields Z self -> $field, $value {
            if $field {
                %fields{$field} = $value;
            }
        }
        return %fields;
    }
}

class Table is Array {
    has $.key is rw;    ## The name of the table.
    has @!hashes;       ## An array of hashes.
    has @!flat;         ## A flat version of the array.

    method hashes ($rebuild?) {
        if $rebuild {
            @!hashes.splice;
        }
        if !@!hashes {
            my @table = self;
            my $fields = @table.shift;
            for @table -> $row {
                if $row !~~ Array { die "Row was not an array"; }
                my %hash = $row.hashMap($fields);
                @!hashes.push: {%hash};
            }
        }
        return @!hashes;
    }

    method flatten ($rebuild?) {
        if $rebuild {
            @!flat.splice;
        }
        if !@!flat {
            my @table = self;
            for @table -> $row {
                @!flat.push: @($row);
            }
        }
        return @!flat;
    }

    method clear {
        $.key = '';
        self.splice;
        @!hashes.splice;
        @!flat.splice;
    }

}

