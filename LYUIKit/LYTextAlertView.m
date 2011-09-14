#import "LYTextAlertView.h"

@implementation LYTextAlertView

@synthesize delegate;
@synthesize action_done;
@synthesize text_fields;

- (id)initWithTitle:(NSString*)title message:(NSString*)message count:(NSInteger)count
{
	return [self initWithTitle:title message:message confirm:@"OK" cancel:@"Cancel" count:count];
}

- (id)initWithTitle:(NSString*)title message:(NSString*)message confirm:(NSString*)confirm cancel:(NSString*)cancel count:(NSInteger)count
{
	int				i;
	UITextField*	field;
	NSString*		spaces;

	self = [super init];
	if (self != nil)
	{
		action_done = nil;
		spaces = @"\n";
		for (i = 0; i < count; i++)
			spaces = [spaces stringByAppendingString:@"\n\n"];

		alert = [[UIAlertView alloc] initWithTitle:title message:[message stringByAppendingString:spaces]
										  delegate:self cancelButtonTitle:cancel otherButtonTitles:confirm, nil];

		alert.delegate = self;
		text_fields = [[NSMutableArray alloc] init];
		for (i = 0; i < count; i++)
		{
			field = [[UITextField alloc] initWithFrame:CGRectMake(10, 80 + 36 * i, 260, 27)];
			field.borderStyle = UITextBorderStyleRoundedRect;
			field.clearButtonMode = UITextFieldViewModeWhileEditing;
			field.autocorrectionType = UITextAutocorrectionTypeNo;
			field.autocapitalizationType = UITextAutocapitalizationTypeNone;
			if (i == count - 1)
				field.returnKeyType = UIReturnKeyDone;
			else
				field.returnKeyType = UIReturnKeyNext;
			field.text = @"";
			field.delegate = self;
			[text_fields addObject:field];
			[alert addSubview:field];
			if (i == 0)
				[field becomeFirstResponder];
		}
		//	[self show];
	}
	return self;
}

- (void)dealloc
{
	[alert release];
	[text_fields release];
	[super dealloc];
}

- (void)show
{
	[alert show];
}

- (void)set_placeholder:(NSInteger)index with:(NSString*)s
{
	UITextField* field;
	if (index >= text_fields.count)
	{
		NSLog(@"WARNING: text alert view index exceeded");
		return;
	}

	field = [text_fields objectAtIndex:index];
	field.placeholder = s;
}

- (void)set_text:(NSInteger)index with:(NSString*)s
{
	UITextField* field;
	if (index >= text_fields.count)
	{
		NSLog(@"WARNING: text alert view index exceeded");
		return;
	}

	field = [text_fields objectAtIndex:index];
	field.text = s;
}

- (NSString*)get_text:(NSInteger)index
{
	return [[text_fields objectAtIndex:index] text];
}

#pragma mark delegate

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//	NSLog(@"got index: %i", buttonIndex);
	//	if (buttonIndex == 1)
	{
		if ((action_done != nil) && (buttonIndex == 1))
			[delegate perform_string:action_done];
		else if (delegate != nil)
		{
			if ([delegate respondsToSelector:@selector(alertView:clickedButtonAtIndex:)])
				[delegate alertView:alert clickedButtonAtIndex:buttonIndex];
		}
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if ([text_fields indexOfObject:textField] == text_fields.count - 1)
	{
		NSLog(@"done");
		[self alertView:alert clickedButtonAtIndex:1];
		[alert dismissWithClickedButtonIndex:1 animated:YES];
	}
	else
	{
		NSLog(@"next");
		[[text_fields objectAtIndex:[text_fields indexOfObject:textField] + 1] becomeFirstResponder];
	}
	return YES;
}

@end
