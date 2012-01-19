#!/usr/bin/php
<?php

function deep_ksort(&$arr) { 
	ksort($arr); 
	foreach ($arr as &$a) { 
		if (is_array($a) && !empty($a)) { 
			deep_ksort($a); 
		} 
	} 
}

function cmd_input($prompt = 'Value')
{
	echo "$prompt: ";
	system('stty echo');
	$ret = trim(fgets(STDIN));
	system('stty echo');
	return $ret;
}

function loop_select($query)
{
	global $sdb;
	$result = $sdb->select($query);
	$result = reorganize_data($result->body->Item());
	sort($result['columns']);
	deep_ksort($result['rows']);
	echo "---- columns ----\n";
	print_r($result['columns']);
	echo "---- rows ----\n";
	if (count($result['rows']) > 0)
	{
		foreach ($result['rows'] as $array)
		{
			foreach ($array as $key => $attrs)
			{
				echo str_pad("$key:", 16, ' ', STR_PAD_RIGHT);
				if (is_array($attrs))
					foreach ($attrs as $attr)
						echo "  $attr\n";
				else
					echo "  $attrs\n";
			}
			echo "----\n";
		}
	}
	echo "---- end ----\n";
}

//	php test.php select 'count(*) from `posts` where `pos-a7` = "Australia"'

define('AWS_KEY', 'AKIAIG737NOEC2VVPXQQ');
define('AWS_SECRET_KEY', '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');

$process_user	= false;
$process_photo	= true;

//require('/Users/leo/prj/sdk/aws/sdk-1.4.3/sdk-1.4.3/sdk.class.php');
require('/Users/leo/prj/sdk/aws/sdk-1.5.0.1/sdk-1.5.0.1/sdk.class.php');
$sdb	= new AmazonSDB();
$s3		= new AmazonS3();

$query_prefix = '';
if ($argc > 1)
{
	switch ($argv[1])
	{
	case '?':
	case 'help':
		echo "aws.php \ select * from posts limit 1\n";
		echo "aws.php all \ users limit 1\n";
		echo "aws.php select * from posts where ...\n";
		echo "aws.php put test name001 key1 value1\n";
		echo "aws.php replace test name001 key1 value0\n";
		echo "aws.php delete test name001\n";
		echo "\tEMPTY: repeat last command\n";
		echo "\tr: display 10 blank lines\n";
		echo "\tq: quit\n";
		echo "\n";
		die;
	case 'all':
		$query_prefix = 'select * from ';
		break;
	case 'put':
		$sdb->put_attributes($argv[2], $argv[3], array($argv[4] => $argv[5]));
		die;
	case 'replace':
		$sdb->put_attributes($argv[2], $argv[3], array($argv[4] => $argv[5]), true);
		die;
	case 'delete':
		$sdb->delete_attributes($argv[2], $argv[3]);
		die;
	case 'select':
		$query = '';
		for ($i = 1; $i < $argc; $i++)
		{
			if ($argv[$i] != 'aws.php')
				$query .= $argv[$i] . ' ';
			else
				$query .= '*';
		}
		//	print_r($argv);
		//	echo "$query\n";
		loop_select($query);
		die;
	/*
	case 'select':
		$result = $sdb->select("select {$argv[2]}");
		$result = reorganize_data($result->body->Item());
		print_r($result);
		echo count($result) . "\n";	die;
	case 'delete':
		$result = $sdb->select("delete {$argv[2]}");
		$result = reorganize_data($result->body->Item());
		print_r($result);
		echo count($result) . "\n";	die;
	 */
	}
}

$last_query = 'select * from posts limit 2';
do {
	$query = cmd_input('query');
	if ($query == '')
		$query = $last_query;
	else if ($query == 'q')
		die;
	else if ($query == 'r')
	{
		echo "\n\n\n\n\n\n\n\n\n\n";
		continue;
	}
	else
		$last_query = $query;
	//	echo "$query_prefix$query\n";
	loop_select($query_prefix . $query);
}	while ($query != '');
die;

$s = file_get_contents('/Users/leo/prj/iphone/sps/data/db/data1.txt');
$a = json_decode($s);
$index = 0;
foreach ($a as $item)
{
	//	print_r($item);
	$mail	= $item->{'mail'};
	$name	= $item->{'name'};
	$a1		= $item->{'a1'};
	$a2		= $item->{'a2'};
	$a3		= $item->{'a3'};
	$a4		= $item->{'a4'};
	$a5		= $item->{'a5'};
	$a6		= $item->{'a6'};
	$a7		= $item->{'a7'};
	$addr	= $item->{'addr'};
	$blob	= $item->{'blob'};
	$date	= $item->{'date'};
	$desc	= $item->{'desc'};
	$lat	= $item->{'lat'};
	$lon	= $item->{'lon'};
	$title	= $item->{'title'};
	$udid	= $item->{'udid'};
	$uid	= $item->{'uid'};
	if ($mail != 'webmanager@slq.qld.gov.au')
	{
		echo "$index:\t$mail\n";
		if ($process_user)
		{
			$users[$mail] = $name;
		}
		if ($process_photo)
		{
			$photo = array();
			//	$photo['uid'] = $uid;
			$photo['author-mail'] = $mail;
			$photo['author-name'] = $name;
			$photo['author-udid'] = $udid;
			$photo['author-app'] = 'org.superarts.PhotoShare';
			$photo['date-create'] = $date;
			$photo['text-title'] = $title;
			$photo['text-body'] = $body;
			$photo['photo-main'] = $blob;
			$photo['pos-a1'] = $a1;
			$photo['pos-a2'] = $a2;
			$photo['pos-a3'] = $a3;
			$photo['pos-a4'] = $a4;
			$photo['pos-a5'] = $a5;
			$photo['pos-a6'] = $a6;
			$photo['pos-a7'] = $a7;
			$photo['pos-addr'] = $addr;
			$photo['pos-lat'] = $lat;
			$photo['pos-lon'] = $lon;
			//	echo "$blob\n";
			$s = file_get_contents("http://cocoa-china.appspot.com/blob/serve/$blob");
			/*
			$fp = fopen('_s3_upload_tmp.jpg', 'wb');
			fwrite($fp, $s);
			fclose($fp);
			 */
			$result = $s3->create_object('us-general', "raw/$blob", array('body' => $s, 'acl' => AmazonS3::ACL_PUBLIC));
			print_r($result->status);
			//	die;
			//	print_r($photo);
			//	$result = $sdb->put_attributes('posts', $uid, $photo);
		}
	}
	$index++;
}
if ($process_user)
{
	$index = 0;
	foreach ($users as $mail => $name)
	{
		echo "$index:\t$mail\t$name\n";
		$result = $sdb->put_attributes('users', $mail, array('name-display' => $name));
		$index++;
	}
}
die;

$attr = $sdb->put_attributes('users', 'php@test.com', array(
	'Attr' => 'v01'
));
print_r($attr);

function reorganize_data($items)
{
	// Collect rows and columns
	$rows = array();
	$columns = array();

	// Loop through each of the items
	if ($items != null)
	{
		foreach ($items as $item)
		{
			// Let's append to a new row
			$row = array();
			$row['id'] = (string) $item->Name;

			// Loop through the item's attributes
			foreach ($item->Attribute as $attribute)
			{
				// Store the column name
				$column_name = (string) $attribute->Name;

				// If it doesn't exist yet, create it.
				if (!isset($row[$column_name]))
				{
					$row[$column_name] = array();
				}

				// Append the new value to any existing values
				// (Remember: Entries can have multiple values)
				$row[$column_name][] = (string) $attribute->Value;
				natcasesort($row[$column_name]);

				// If we've not yet collected this column name, add it.
				if (!in_array($column_name, $columns, true))
				{
					$columns[] = $column_name;
				}
			}

			// Append the row we created to the list of rows
			$rows[] = $row;
		}
	}

	// Return both
	return array(
		'columns' => $columns,
		'rows' => $rows,
	);
}

?>
