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
	# for ((i=0; i<$FIELD_SIZE; i++)) do
		# temp=();
		# for ((j=0; j<$FIELD_SIZE; j++)) do temp[$j]=$EMPTY_CELL; done;
		# field[$i]=${temp[@]};
	field_length=$(($FIELD_SIZE*$FIELD_SIZE));
	for ((i=0; i<$field_length; i++)) do
		field[$i]=$EMPTY_CELL;
	done;
	field
}

field(){
	for ((i=0; i<$FIELD_SIZE; i++)) do
		# for ((j=0; j<${#field[@]}; j++)) do 
		# 	print_cell ${field[$i][$j]};
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
	elif [ $1 == $PLAYER_ONE_CELL ]; then
		set_blue;
	elif [ $1 == $PLAYER_TWO_CELL ]; then
		set_red;
	fi

	printf $1
	set_black;
}

make_move(){
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
}

first(){
	make_move $1 $2 1;
}

second(){
	make_move $1 $2 2;
}
