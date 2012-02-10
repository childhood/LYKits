#import "LYFlipImageView.h"


@implementation LYFlipImageView

@synthesize data;

- (id)initWithFrame:(CGRect)rect
{
	self = [super initWithFrame:rect];
	if (self)
	{
		data = [[NSMutableDictionary alloc] init];
		[data key:@"sequence" v:[[NSMutableArray alloc] init]];
		[self set_sequence_numbers];

		UILabel* label1 = [[UILabel alloc] initWithFrame:rect];
		label1.textColor = [UIColor whiteColor];
		label1.textAlignment = UITextAlignmentCenter;
		label1.backgroundColor = [UIColor blackColor];
		label1.font = [UIFont systemFontOfSize:128];
		label1.minimumFontSize = 10;
		label1.adjustsFontSizeToFitWidth = YES;
		UILabel* label2 = [[UILabel alloc] initWithFrame:rect];
		[label2 copy_style:label1];
		[data key:@"label1" v:label1];
		[data key:@"label2" v:label2];

		[data key:@"state" v:@""];
		[data key:@"mode" v:@"text"];
		[data key:@"index" v:[NSNumber numberWithInt:0]];
		[self set_sequence_numbers];
		[self reload];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
	[data release];
}

- (void)set_sequence_numbers
{
	NSMutableArray* array = [data v:@"sequence"];
	[array removeAllObjects];
	for (char c = '0'; c <= '9'; c++)
		[array addObject:[NSString stringWithFormat:@"%c", c]];
}

- (void)set_sequence_lowercase
{
	NSMutableArray* array = [data v:@"sequence"];
	[array removeAllObjects];
	for (char c = 'a'; c <= 'z'; c++)
		[array addObject:[NSString stringWithFormat:@"%c", c]];
}

- (void)set_sequence_uppercase
{
	NSMutableArray* array = [data v:@"sequence"];
	[array removeAllObjects];
	for (char c = 'A'; c <= 'Z'; c++)
		[array addObject:[NSString stringWithFormat:@"%c", c]];
}

- (void)reload
{
	//[self reload:[data v:@"index"]];
	NSArray* sequence = [data v:@"sequence"];
	int index = [[data v:@"index"] intValue];

	if ([[data v:@"mode"] is:@"text"])
	{
		UILabel* label1 = [data v:@"label1"];
		label1.text = [sequence i:index];
		self.image = [label1 snapshot];
	}
	else if ([[data v:@"mode"] is:@"image"])
	{
		self.image = [UIImage imageNamed:[sequence i:index]];
	}
}

- (void)reload:(NSNumber*)number
{
	NSArray* sequence = [data v:@"sequence"];
	int index = [number intValue];

	if ([[data v:@"mode"] is:@"text"])
	{
		[self.image release];
		self.image = nil;
		UILabel* label1 = [data v:@"label1"];
		label1.text = [sequence i:index];
		self.image = [label1 snapshot];
	}
	else if ([[data v:@"mode"] is:@"image"])
	{
		self.image = [UIImage imageNamed:[sequence i:index]];
	}

	index++;
	if (index >= sequence.count)
		index = 0;

	if ([[data v:@"mode"] is:@"text"])
	{
		[self.highlightedImage release];
		self.highlightedImage = nil;
		UILabel* label2 = [data v:@"label2"];
		label2.text = [sequence i:index];
		self.highlightedImage = [label2 snapshot];
	}
	else if ([[data v:@"mode"] is:@"image"])
	{
		self.highlightedImage = [UIImage imageNamed:[sequence i:index]];
	}

	[self clock_flip];

	NSLock* lock = [ly.data v:@"lock-flip-sound"];
	if ([lock tryLock])
	{
		NSString* s = [ly.data v:@"clock-flip-progress"];
		se_play_caf([NSString stringWithFormat:@"ly-flip-clock%@", s]);
#if 1
		if ([s is:@"1"])
			[ly.data key:@"clock-flip-progress" v:@"2"];
		else
			[ly.data key:@"clock-flip-progress" v:@"1"];
#endif
		[self performSelector:@selector(sound_unlock) withObject:nil afterDelay:0.15];
	}
}

- (NSString*)value
{
	NSArray* sequence = [data v:@"sequence"];
	int index = [[data v:@"index"] intValue];
	return [sequence i:index];
}

- (BOOL)flip_to:(NSString*)s
{
	int index = [[data v:@"index"] intValue];
	int i = 0;
	CGFloat f = [[[ly data] v:@"animation-clock-flip-duration"] floatValue];
	if ([[data v:@"state"] is:@"locked"])
		return NO;
	[data key:@"state" v:@"locked"];
	while ([[[data v:@"sequence"] i:index] is:s] == NO)
	{
		//	NSLog(@"current: %@\t%@", [[data v:@"sequence"] i:index], s);
		[self performSelector:@selector(reload:) withObject:[NSNumber numberWithInt:index] afterDelay:(f + 0.05) * i];
		i++;
		index++;
		if (index >= [[data v:@"sequence"] count])
			index = 0;
	}
	[data key:@"index" v:[NSNumber numberWithInt:index]];
	[self performSelector:@selector(set_state:) withObject:@"" afterDelay:(f + 0.05) * (i - 1) + f];

	return YES;
}

- (void)sound_unlock
{
	[[ly.data v:@"lock-flip-sound"] unlock];
}

- (void)set_state:(NSString*)s
{
	//	NSLog(@"set state: %@", s);
	[data key:@"state" v:s];
}

@end
