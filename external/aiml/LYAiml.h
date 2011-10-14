#include "std_util.h"
#include <fstream>
#include <iostream>
#include "aiml.h"
//	#include "LYString.h"

//	extern "C" int test_app_main(void);

@interface LYAiml: NSObject
{
	aiml::cInterpreter*		interpreter;
	NSMutableDictionary*	data;
}
@property (retain, nonatomic) NSMutableDictionary*	data;

- (int)load;
- (NSString*)respond:(NSString*)s;

@end
