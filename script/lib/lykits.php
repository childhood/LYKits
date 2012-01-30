<?php

require('/usr/local/lib/liblykits.php');

function cmd_input($prompt = 'Value')
{
	echo "$prompt: ";
	system('stty echo');
	$ret = trim(fgets(STDIN));
	system('stty echo');
	return $ret;
}

?>
