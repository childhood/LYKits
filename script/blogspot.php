<?php

$title = 'Untitled 1';
$content = 'This is a test.<br>这是一个测试。<hr>Testing...';
$labels = array('label2', 'label3');
$user = 'superartstudio@gmail.com';
$pass = 'Mtphtrdmtp!415926535';

set_include_path('/Users/iphone/prj/sdk/zend/library');
require_once 'Zend/Loader.php';

Zend_Loader::loadClass('Zend_Gdata');
Zend_Loader::loadClass('Zend_Gdata_Query');
Zend_Loader::loadClass('Zend_Gdata_ClientLogin');

$client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, 'blogger');
$gdClient = new Zend_Gdata($client);

$query = new Zend_Gdata_Query('http://www.blogger.com/feeds/default/blogs');
$feed = $gdClient->getFeed($query);
printFeed($feed);
$input = getInput("\nChoose the blog you want to publish");
//id text is of the form: tag:blogger.com,1999:user-blogID.blogs
$idText = explode('-', $feed->entries[$input]->id->text);
$blogID = $idText[2];
echo "blog id: $blogID\n";

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
