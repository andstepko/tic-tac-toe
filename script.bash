#!/bin/bash
#(c) Andrii Stepko (PI-13-1)
FIELD_SIZE=3;
EMPTY_CELL=0;
PLAYER_ONE_CELL=1;
PLAYER_TWO_CELL=2;

clear_console(){ echo -en "\033c";}

set_blue(){ echo -en "\e[44m";}

set_red(){ echo -en "\e[41m";}

set_black(){ echo -en "\e[40m";}

set_default(){ echo -en "\e[0m";}

# Starts a new game.
new(){
	field=();
	field_length=$(($FIELD_SIZE*$FIELD_SIZE));
	for ((i=0; i<$field_length; i++)) do
		field[$i]=$EMPTY_CELL;
	done;

	winner=0;
	turn=1;
	
	field
}

# Prints current game field into console.
field(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		for ((j=0; j<$FIELD_SIZE; j++)) do
			t=$(($i*$FIELD_SIZE+$j));
			print_cell ${field[$t]}
		done;
		printf '\n'
	done;

	if [ $winner == 0 ]; then
		if [ $turn == 1 ]; then
			echo "First player (O):"
		else
			echo "Second player (X):"
		fi
	fi
}

# Prints a cell of a field into console. 1) cell's value.
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

	set_default;
}

# Makes player's move. 1) row number; 2) column number.
move(){
	if [ $winner == 0 ]; then
		if [ $turn == 1 ]; then
			first $1 $2
		elif [ $turn == 2 ]; then
			second $1 $2
		fi
	else
		echo_winners
		field
	fi
}

# Makes move of the first player. 1) row number; 2) column number.
first(){
	move_forcibly $1 $2 1;
	res=$?
	if [ $res == 1 ] ; then
		turn=2;
		echo_winners
		field;
	fi
}

# Makes move of the second player. 1) row number; 2) column number.
second(){
	move_forcibly $1 $2 2;
	res=$?
	if [ $res == 1 ] ; then
		turn=1;
		echo_winners
		field;
	fi
}

# Makes move of a player. 1) row number; 2) column number; 3) player's number.
move_forcibly(){
	if (($1 >= $FIELD_SIZE)) || (($2 >= $FIELD_SIZE)); then
		echo "Error index out of range.";
		return 0;
	fi

	cell_index=$(($1*$FIELD_SIZE+$2));
	if [ ${field[$cell_index]} != 0 ]; then
		echo "Error cell is already not empty.";
		return 0;
	fi

	field[$cell_index]=$3;
	return 1;
}

# Prints the winner into console, if any exists.
echo_winners(){
	is_some_line_full 1;
	res=$?
	if [ $res == 1 ] ; then
		winner=1;
		echo "First payer won (O)!"
		return 1;
	fi

	is_some_line_full 2;
	res=$?
	if [ $res == 1 ] ; then
		winner=2;
		echo "Second payer won (X)!"
		return 1;
	fi
}

# Returns 1 if there is some full line in the field or 0 otherwise. 1)user number.
is_some_line_full(){
	for ((k=0; k<$FIELD_SIZE; k++)) do
		is_row_full $k $1
		res=$?
		if [ $res == 1 ]; then
			return 1;
		fi

		is_column_full $k $1
		res=$?
		if [ $res == 1 ]; then
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

# returns 1 if particular row is full and zero otherwise. 1)row index; 2) payer's number;
is_row_full(){
	for ((j=0; j<$FIELD_SIZE; j++)) do
		t=$(($1*$FIELD_SIZE+$j));
		if [ ${field[$t]} != $2 ]; then
			return 0;
		fi
	done;
	return 1;
}

# returns 1 if particular row is full and 0 otherwise. 1)row index; 2) payer's number;
is_column_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$1));
		if [ ${field[$t]} != $2 ]; then
			return 0;
		fi
	done;
	return 1;
}

# returns 1 if main diagonal is full and 0 otherwise. 1)payer's number;
is_main_diag_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$i));
		if [ ${field[$t]} != $1 ]; then
			return 0;
		fi
	done;
	return 1;
}

# returns 1 if secondary diagonal is full and 0 otherwise. 1)payer's number;
is_secondary_diag_full(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		t=$(($i*$FIELD_SIZE+$FIELD_SIZE-$i-1));
		if [ ${field[$t]} != $1 ]; then
			return 0;
		fi
	done;
	return 1;
}
