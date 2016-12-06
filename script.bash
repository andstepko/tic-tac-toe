FIELD_SIZE=3;
EMPTY_CELL=0;
PLAYER_ONE_CELL=1;
PLAYER_TWO_CELL=2;

clear_console(){ echo -en "\033c";}

set_blue(){ echo -en "\033[1;44m";}

set_red(){ echo -en "\033[1;41m";}

set_black(){ echo -en "\033[1;40m";}

new(){
	field=();
	field_length=$(($FIELD_SIZE*$FIELD_SIZE));
	for ((i=0; i<$field_length; i++)) do
		field[$i]=$EMPTY_CELL;
	done;
	field
}

field(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		for ((j=0; j<$FIELD_SIZE; j++)) do
			t=$(($i*$FIELD_SIZE+$j));
			print_cell ${field[$t]}
		done;
		printf '\n'
	done;
}

print_cell(){
	if [ $1 == $EMPTY_CELL ]; then
		set_black;
		printf ' '
	elif [ $1 == $PLAYER_ONE_CELL ]; then
		set_blue;
		printf O
	elif [ $1 == $PLAYER_TWO_CELL ]; then
		set_red;
		printf X
	fi

	set_black;
}

move(){
	if (($1 >= $FIELD_SIZE)) || (($2 >= $FIELD_SIZE)); then
		echo "Error index out of range.";
		return 1;
	fi

	cell_index=$(($1*$FIELD_SIZE+$2));
	if [ ${field[$cell_index]} != 0 ]; then
		echo "Error cell is already not empty.";
		return 1;
	fi

	field[$cell_index]=$3;
	field;

	is_some_line_full 1;
	res=$?
	if [ $res == 1 ] ; then
		echo "First payer won!"
	fi
	is_some_line_full 2;
	res=$?
	if [ $res == 1 ] ; then
		echo "Second payer won!"
	fi
}

first(){
	move $1 $2 1;
}

second(){
	move $1 $2 2;
}

is_some_line_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		is_row_full $i $1
		res=$?
		if [ $res == 1 ] ; then
			return 1;
		fi

		is_column_full $i $1
		res=$?
		if [ $res == 1 ] ; then
			return 1;
		fi
	done;

	is_main_diag_full $1
	res=$?
	if [ $res == 1 ] ; then
		return 1;
	fi
	is_secondary_diag_full $1
	res=$?
	if [ $res == 1 ] ; then
		return 1;
	fi

	return 0;
}

is_row_full(){
	for ((j=0; j<$FIELD_SIZE; j++)) do
		t=$(($1*$FIELD_SIZE+$j));
		if [ ${field[$t]} != $2 ]; then
			return 0;
		fi
	done;
	return 1;
}

is_column_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$1));
		if [ ${field[$t]} != $2 ]; then
			return 0;
		fi
	done;
	return 1;
}

is_main_diag_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$i));
		if [ ${field[$t]} != $1 ]; then
			return 0;
		fi
	done;
	return 1;
}

is_secondary_diag_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$FIELD_SIZE-$i-1));
		if [ ${field[$t]} != $1 ]; then
			return 0;
		fi
	done;
	return 1;
}
