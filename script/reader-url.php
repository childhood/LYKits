#!/usr/bin/php
<?php

if ($argc < 2)
{
	echo "usage: {$argv[0]} 'http://demo.blogspot.com'\n";
	die;
}
$url = $argv[1];
$url = urlencode($url);
echo "https://www.google.com/reader/public/atom/feed/$url\n";

?>
