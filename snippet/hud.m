#import "LYKits.h"

- (void)hud_display
{
	hud = [ly.data v:@"ui-hud"];
	[nav.view addSubview:hud.view];

	[hud setFixedSize:CGSizeMake(240, 160)];
	[hud setCaption:@"msg"];
	[hud show];
}

- (void)hud_dismiss:(ATMHud*)a_hud
{
	NSLog(@"hud dismissed: %@", a_hud);
}
