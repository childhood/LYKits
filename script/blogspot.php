#!/usr/bin/php
<?php

require('lib/lykits.php');

if ($argc <= 1)
{
	echo "Usage:\n";
	echo "\tblogspot.php id\n";
	echo "\tblogspot.php create 7374011382191647920 TITLE content.html label1 [label2 ...]\n";
	echo "\tblogspot.php upload 7374011382191647920 PATH label1 [label2 ...]\n";
	echo "\t\tPATH/list.txt\n";
	echo "\t\tPATH/filename1.txt\n";
	echo "\t\tPATH/filename2.txt\n";
	echo "\t\t...\n";
	die;
}
$user = $ly_gdata_username;
$pass = $ly_gdata_password;

Zend_Loader::loadClass('Zend_Gdata');
Zend_Loader::loadClass('Zend_Gdata_Query');
Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

$client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, 'blogger');
$gdClient = new Zend_Gdata($client);

switch (strtolower($argv[1]))
{
case 'id':
	$query = new Zend_Gdata_Query('http://www.blogger.com/feeds/default/blogs');
	$feed = $gdClient->getFeed($query);
	printFeed($feed);
	$input = getInput("\nChoose the blog you want to publish");
	//id text is of the form: tag:blogger.com,1999:user-blogID.blogs
	$idText = explode('-', $feed->entries[$input]->id->text);
	$blogID = $idText[2];
	echo "blog id: $blogID\n";

	break;
case 'create':
	$blogID = $argv[2];
	$title = $argv[3];
	if (file_exists($argv[4]))
		$content = file_get_contents($argv[4]);
	else
		$content = $argv[4];
	$labels = array();
	for ($i = 5; $i < $argc; $i++)
		$labels[] = $argv[$i];
	//	print_r($labels);

	$entry = $gdClient->newEntry();
	$entry->title = $gdClient->newTitle(trim($title));
	$entry->content = $gdClient->newContent(trim($content));
	$entry->content->setType('text');
	$categories = array();
	foreach ($labels as $s)
		$categories[] = $gdClient->newCategory($s, 'http://www.blogger.com/atom/ns#');
	$entry->category = $categories;
	$uri = "http://www.blogger.com/feeds/" . $blogID . "/posts/default";

	$createdPost = $gdClient->insertEntry($entry, $uri);
	//format of id text: tag:blogger.com,1999:blog-blogID.post-postID
	$idText = explode('-', $createdPost->id->text);
	$postID = $idText[2];
	echo "post id: $postID\n";

	break;
case 'upload':
	$blogID	= $argv[2];
	$path	= $argv[3];
	$label	= '';
	for ($i = 4; $i < $argc; $i++)
		$label .= "'{$argv[$i]}' ";

	//echo "$path\n$title\n";
	$a = file("$path/list.txt");
	$index = 0;
	foreach ($a as $s)
	{
		$ss = substr($s, 0, -1);
		if ($ss != '')
		{
			$filename = "$path/$ss.txt";
			$cmd = "{$argv[0]} create '$blogID' '$ss' '$filename' $label";
			//	echo "$cmd\n";
			echo "$index.\tAdding '$ss'...\n";
			system($cmd);
		}
		$index++;
		if ($index >= 20)
		{
			cmd_input('Press any key to continue');
			$index = 0;
		}
	}
	break;
default:
	echo "Unknown command '{$argv[1]}'...\n";
	system($argv[0]);
	die;
}

function printFeed($feed)
{
	$i = 0;
	foreach($feed->entries as $entry)
	{
		echo "\t" . $i ." ". $entry->title->text . "\n";
		$i++;
	}
}

function getInput($text)
{
    echo $text.': ';
    return trim(fgets(STDIN));
}
