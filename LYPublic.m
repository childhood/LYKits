#import "LYPublic.h"

//	test functions will be put here, and moved to other places once tested

void ly_upload_file(NSString* filename, NSString* arg_id, NSString* desc)
{
	NSString*	post;
	NSString*	s;
	NSMutableURLRequest*	request;

#if 0
	NSDictionary* dict = [[NSDictionary alloc] initWithContentsOfFile:filename];
	post = [dict.description to_url];
	NSLog(@"contents of %@: %@", filename, post);
	[dict release];
#endif
	post = [NSString stringWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:nil];
	post = [post stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
	post = [post stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
	post = [post stringByReplacingOccurrencesOfString:@";" withString:@"%3B"];

	post = [NSString stringWithFormat:@"id=%@&desc=%@&data=%@&username=test&password=passwordtest", arg_id, desc, post];
	NSData*		postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];  
	NSString*	postLength = [NSString stringWithFormat:@"%d", [postData length]];  
	  
	request = [[[NSMutableURLRequest alloc] init] autorelease];  
	//[request setURL:[NSURL URLWithString:@"http://localhost:8080/database/put"]];  
	//[request setURL:[NSURL URLWithString:@"http://i.superarts.org/database/put"]];  
	[request setURL:[NSURL URLWithString:@"https://cocoa-china.appspot.com/database/put"]];  
	[request setHTTPMethod:@"POST"];  
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];  
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];  
	[request setHTTPBody:postData];  

	NSLog(@"saving in database...");
	NSData* ret = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	s = [[NSString alloc] initWithData:ret encoding:NSUTF8StringEncoding];
	NSLog(@"result: %@", s);
	[s release];
}
