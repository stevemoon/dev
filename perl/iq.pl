#!/usr/bin/perl

@initial_board=(0,1,1,1,1,1,1,1,1,1,1,1,1,1,1);
$adjc{"0"}=[2,1,3,2,5];
$adjc{"1"}=[2,3,6,4,8];
$adjc{"2"}=[2,5,9,4,7];
$adjc{"3"}=[4,1,0,4,5,6,10,7,12];
$adjc{"4"}=[2,7,11,8,13];
$adjc{"5"}=[4,2,0,4,3,8,12,9,14];
$adjc{"6"}=[2,3,1,7,8];
$adjc{"7"}=[2,4,2,8,9];
$adjc{"8"}=[2,4,1,7,6];
$adjc{"9"}=[2,5,2,8,7];
$adjc{"10"}=[2,6,3,11,12];
$adjc{"11"}=[2,7,4,12,13];
$adjc{"12"}=[4,7,3,8,5,11,10,13,14];
$adjc{"13"}=[2,8,4,12,11];
$adjc{"14"}=[2,9,5,13,12];
<<<<<<< HEAD
@names=qw(A B C D E F G H I J K L M N O);
=======
@names=qw(A1 B1 B2 C1 C2 C3 D1 D2 D3 D4 E1 E2 E3 E4 E5);
>>>>>>> origin/master

my @n_board=@initial_board;
my @moves_so_far_base = ();
print_board(@n_board);
solve(\@n_board, \@moves_so_far_base);
print_board(@n_board);

sub get_moves {
	my $board = shift;
	my $peg = 0;
	my $pm = 0;
	my @movelist;
	my $tuples;
	my $take;
	my $moveto;
	for ($peg = 0; $peg <= 14; $peg++) {
		@adjcl=@{$adjc{"$peg"}};
		$tuples=$adjcl[0];
		$tuples = $tuples * 2;
		for ($pm = 1; $pm < $tuples; $pm+=2) {
			$take = $adjcl[$pm];
			$moveto = $adjcl[$pm+1];
			if ((@$board[$peg]) && (@$board[$take]) && (@$board[$moveto]==0)) {
				push @movelist, $peg, $take, $moveto;
				}
		}
	}
	return \@movelist;
}

sub move {
	my $board = shift;
	my $peg = shift;
	my $take = shift;
	my $moveto = shift;
	@$board[$peg]=0;
	@$board[$take]=0;
	@$board[$moveto]=1;
}

sub solve {
	my $board = shift;
	my $moves_so_far = shift;
	my $moves = get_moves($board);
	if (scalar @$moves < 3) {
		print @$moves_so_far;
		print " (" . (14 - (scalar @$moves_so_far)) . " pegs remain)\n";
		@$moves_so_far = ();
		return;
	}
	elsif (scalar @$moves >= 3) {
		my $mv_idx = 0;
		my $peg;
		my $take;
		my $moveto;
		for ($mv_idx=0; $mv_idx<(scalar @$moves); $mv_idx+=3) {
			($peg, $take, $moveto) = @$moves[$mv_idx, $mv_idx+1,$mv_idx+2];
			#my @new_board = map { [@$_] } @$board;
			my @new_board = @$board;
			move (\@new_board, $peg, $take, $moveto);
			my @new_moves = ();
			@new_moves = @$moves_so_far;
<<<<<<< HEAD
			push @new_moves, $names[$peg] . "x" . $names[$take] . "->" . $names[$moveto] . " ";
=======
			push @new_moves, $names[$peg] . "x" . $names[$take] . " ";
>>>>>>> origin/master
			solve (\@new_board, \@new_moves);
		}
	}
}

sub print_board {
	my @board = @_;
<<<<<<< HEAD
	print "    @board[0]\n";
	print "   @board[1] @board[2]\n";
	print "  @board[3] @board[4] @board[5]\n";
	print " @board[6] @board[7] @board[8] @board[9]\n";
	print "@board[10] @board[11] @board[12] @board[13] @board[14]\n";
=======
	print "\t\t\t\t@board[0]\n";
	print "\t\t\t@board[1]\t@board[2]\n";
	print "\t\t@board[3]\t@board[4]\t@board[5]\n";
	print "\t@board[6]\t@board[7]\t@board[8]\t@board[9]\n";
	print "@board[10]\t@board[11]\t@board[12]\t@board[13]\t@board[14]\n";
>>>>>>> origin/master
	print "\n";
}
