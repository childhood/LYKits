#import "LYServiceUI.h"

@implementation LYServiceUI

@synthesize data;

- (id)init
{
	self = [super initWithNibName:nil bundle:nil];
	if (self != nil)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"db" v:[[LYDatabase alloc] init]];
		[data key:@"nav" v:nil];
		[data key:@"user" v:[@"ly-service-login-user" setting_object]];
		[self loadView];
	}
	return self;
}

- (void)dealloc
{
	[data release];
	[super dealloc];
}

- (UIViewController*)controller_login
{
	//	NSLog(@"login %@", controller_login);
	segment_login_type.selectedSegmentIndex = 0;
	field_login_name.text = [@"ly-service-login-name" setting_string];
	field_login_mail.text = [@"ly-service-login-mail" setting_string];
	field_login_pin1.text = [@"ly-service-login-pin" setting_string];
	field_login_pin2.text = [@"ly-service-login-pin" setting_string];
	return controller_login;
}

- (IBAction)action_login_type
{
	switch (segment_login_type.selectedSegmentIndex)
	{
		case 0:
			field_login_name.hidden = YES;
			field_login_pin2.hidden = YES;
			break;
		case 1:
			field_login_name.hidden = NO;
			field_login_pin2.hidden = NO;
			break;
	}
}

- (IBAction)action_login_done
{
	if (segment_login_type.selectedSegmentIndex == 0)
	{
		//	login
		[LYLoading show_label:@"Logging in..."];
		[[data v:@"db"] sdb:@"user" verify:[NSDictionary dictionaryWithObjectsAndKeys:
			field_login_mail.text,
			@"email",
			field_login_pin1.text,
			@"pin",
			nil] block:^(NSDictionary* dict, NSError* error)
		{
			NSLog(@"error: %@ - %@", error, dict);
			if ((error == nil) && (dict.count > 0))
			{
				[@"ly-service-login-name" setting_string:[dict v:@"name-display"]];
				[@"ly-service-login-mail" setting_string:field_login_mail.text];
				[@"ly-service-login-pin" setting_string:field_login_pin1.text];
				field_login_name.text = [@"account-name" setting_string];
				field_login_pin2.text = [@"account-pin" setting_string];
				[[data v:@"nav"] dismissModalViewControllerAnimated:YES];
				[data key:@"user" v:dict];
				[@"ly-service-login-user" setting_object:dict];
			}
			else
			{
				[@"Login Failed" show_alert_message:@"Your username/password combination is not correct. Please try again or choose \"Register\" to create a new account."];
			}
			[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
		}];
	}
	else
	{
		//	register
		if (field_login_name.text.length < 3)
		{
			[@"Name Too Short" show_alert_message:@"The name you entered is too short. Please choose a valid name."];
			[field_login_name becomeFirstResponder];
			return;
		}
		if ([field_login_mail.text is_email] == NO)
		{
			[@"Invalid E-mail Address" show_alert_message:@"Please enter a valid e-mail address."];
			[field_login_mail becomeFirstResponder];
			return;
		}
		if ([field_login_pin1.text is:field_login_pin2.text] == NO)
		{
			[@"Passwords Mismatch" show_alert_message:@"Please make sure the two passwords you've entered are identical."];
			[field_login_pin1 becomeFirstResponder];
			return;
		}
		if (field_login_pin1.text.length < 5)
		{
			[@"Password Too Short" show_alert_message:@"The password must have at least 5 characters. Please try again."];
			[field_login_pin1 becomeFirstResponder];
			return;
		}
		[LYLoading show_label:@"Checking username..."];
		[[data v:@"db"] insert_user:[NSDictionary dictionaryWithObjectsAndKeys:
			field_login_mail.text,
			@"email",
			field_login_name.text,
			@"name-display",
			field_login_pin1.text,
			@"pin",
			[NSMutableArray arrayWithObjects:
				@"org.superarts.LSM",
				@"org.superarts.LSM-Free",
				nil],
			@"apps",
			[NSMutableArray array],
			@"friends",
			nil] block:^(NSArray* array, NSError* error)
			{
				NSLog(@"result user insert: %@ - %@", error, array);
				if (error == nil)
				{
					[@"account-name" setting_string:field_login_name.text];
					[@"account-mail" setting_string:field_login_mail.text];
					[@"account-pin" setting_string:field_login_pin1.text];
					[[data v:@"nav"] dismissModalViewControllerAnimated:YES];

					//[[data v:@"db"] name:@"db100_model" key:[array objectAtIndex:0] block:^(NSArray* array, NSError* error)
					[[data v:@"db"] sdb:@"user" key:[array objectAtIndex:0] block:^(NSDictionary* dict, NSError* error)
					{
						//	NSLog(@"xxx %@, %@", dict, error);
						[data key:@"user" v:dict];
						[@"ly-service-login-user" setting_object:dict];
					}];
				}
				else
				{
					[@"Registration Failed" show_alert_message:[NSString stringWithFormat:@"Error: %@", error.localizedDescription]];
				}
				//[LYLoading hide];
				[LYLoading performSelector:@selector(hide) withObject:nil afterDelay:0.5];
			}];
	}
}

#pragma mark delegate

- (BOOL)textFieldShouldReturn:(UITextField *)field
{
	if (field == field_login_name)
		[field_login_mail becomeFirstResponder];
	else if (field == field_login_mail)
		[field_login_pin1 becomeFirstResponder];
	else if (field == field_login_pin1)
	{
		if (segment_login_type.selectedSegmentIndex == 0)
			[field_login_pin1 resignFirstResponder];
		else
			[field_login_pin2 becomeFirstResponder];
	}
	else if (field == field_login_pin2)
		[field_login_pin2 resignFirstResponder];

	return YES;
}

@end
