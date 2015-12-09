while (<>) {
	chomp;
	$goober = $_;
	$goober =~ s/^((?:[^()]|\((?1)\))*+)//;
	print $goober;
}
