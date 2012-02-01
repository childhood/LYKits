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

/*
	liblykits example

//	aws
require('/Users/leo/prj/sdk/aws/sdk-1.4.3/sdk-1.4.3/sdk.class.php');
//require('/Users/leo/prj/sdk/aws/sdk-1.5.0.1/sdk-1.5.0.1/sdk.class.php');
define('AWS_KEY', '');
define('AWS_SECRET_KEY', '');

//	gdata
set_include_path('/Users/leo/prj/sdk/zend/library');
require_once 'Zend/Loader.php';
$ly_gdata_username = 'superartstudio@gmail.com';
$ly_gdata_password = '';

 */

?>
