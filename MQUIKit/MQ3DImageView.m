#import "MQ3DImageView.h"

#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

@implementation MQ3DImageView

@synthesize animating;
@synthesize renderer;
@dynamic animationFrameInterval;

- (void)set_mode:(NSInteger)mode
{
	renderer.mode = mode;
}

- (void)set_color:(UIColor*)color
{
	renderer.color_bg = color;
}

// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (animating == YES)
		[self stop];
	else
		[self start];
}

//The EAGL view is stored in the nib file. When it's unarchived it's sent -initWithCoder:
- (id)initWithFrame:(CGRect)frame
//- (id)initWithCoder:(NSCoder*)coder
{    
    if ((self = [super initWithFrame:frame]))
    {
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

        //eaglLayer.opaque = TRUE;
        self.backgroundColor = [UIColor clearColor];
        eaglLayer.opaque = NO;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

		renderer = [[MQES1Renderer alloc] init];

		if (!renderer)
		{
			NSLog(@"ES1 renderer failed");
			[self release];
			return nil;
		}

        animating = FALSE;
        displayLinkSupported = FALSE;
        animationFrameInterval = 1;
        displayLink = nil;
        animationTimer = nil;

        // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
        // class is used as fallback when it isn't available.
        NSString *reqSysVer = @"3.1";
        NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
        if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
            displayLinkSupported = TRUE;

		//	init 3d
		const GLfloat zNear = 0.1, zFar = 1000.0, fieldOfView = 60.0;
		GLfloat size;
		glEnable(GL_DEPTH_TEST);
		glMatrixMode(GL_PROJECTION);
		size = zNear * tanf(DEGREES_TO_RADIANS(fieldOfView) / 2.0);
		// This give us the size of the iPhone display
		CGRect rect = self.bounds;
		glFrustumf(-size, size, -size / (rect.size.width / rect.size.height), size / (rect.size.width / rect.size.height), zNear, zFar);
		glViewport(0, 0, rect.size.width, rect.size.height);
		//glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
		glClearColor(0.0f, 0.0f, 0.0f, 0.0f);

		[self start];
    }

    return self;
}

- (void)setImage:(UIImage*)image
{
	[renderer set_image:image];
}

- (void)set_image:(NSString*)filename
{
	[renderer set_image:[UIImage imageWithContentsOfFile:filename]];
}

- (void)drawView:(id)sender
{
	//	NSLog(@"draw view: %@", renderer);
    [renderer render];
}

- (void)layoutSubviews
{
    [renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
    [self drawView:nil];
}

- (NSInteger)animationFrameInterval
{
    return animationFrameInterval;
}

- (void)setAnimationFrameInterval:(NSInteger)frameInterval
{
    // Frame interval defines how many display frames must pass between each time the
    // display link fires. The display link will only fire 30 times a second when the
    // frame internal is two on a display that refreshes 60 times a second. The default
    // frame interval setting of one will fire 60 times a second when the display refreshes
    // at 60 times a second. A frame interval setting of less than one results in undefined
    // behavior.
    if (frameInterval >= 1)
    {
        animationFrameInterval = frameInterval;

        if (animating)
        {
            [self stop];
            [self start];
        }
    }
}

- (void)start
{
	//	NSLog(@"start animation: %i", animating);
    if (!animating)
    {
        if (displayLinkSupported)
        {
			//	NSLog(@"start animation with display link");
            // CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
            // if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
            // not be called in system versions earlier than 3.1.

            displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
            [displayLink setFrameInterval:animationFrameInterval];
            [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        }
        else
		{
			//	NSLog(@"start animation with timer");
            animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];
		}

		[renderer enable_accelerometer];
        animating = TRUE;
    }
}

- (void)stop
{
    if (animating)
    {
        if (displayLinkSupported)
        {
            [displayLink invalidate];
            displayLink = nil;
        }
        else
        {
            [animationTimer invalidate];
            animationTimer = nil;
        }

		[renderer disable_accelerometer];
        animating = FALSE;
    }
}

- (void)dealloc
{
    [renderer release];

    [super dealloc];
}

@end

//	#import "MQES1Renderer.h"

#define SCREEN_WIDTH	320
#define SCREEN_HEIGHT	480

#define k_height_fix	-1.0
#define k_distance_fix	-0.0

#define k_acc_resolution    		0.1
#define kFilteringFactor            0.3

#define _rad_to_deg(__ANGLE)		((__ANGLE) * 180.0 / M_PI)

void Enable2D()
{
    int width = SCREEN_WIDTH;
    int height = SCREEN_HEIGHT;
    
    glViewport      (0, 0, width, height);
    
    glMatrixMode    (GL_PROJECTION);
    glLoadIdentity  ();
    glOrthof(0, (float)width, 0, (float)height, 0, 100);
    glMatrixMode    (GL_MODELVIEW);
    glLoadIdentity();
    
    glEnable                (GL_BLEND);
    glEnable                (GL_TEXTURE_2D);
    glDisable                (GL_CULL_FACE);
    glDisable                (GL_DEPTH_TEST);
    glDisable                (GL_LIGHTING);
    //glDisableClientState    (GL_NORMAL_ARRAY);
}
void Enable3D()
{    
    int width = SCREEN_WIDTH;
    int height = SCREEN_HEIGHT;
    //float aspect = (float)width/(float)height;
    
    glViewport          (0, 0, width, height);
    glScissor           (0, 0, width, height);
    
    //glMatrixMode        (GL_MODELVIEW);
    //glLoadIdentity      ();
    
    glMatrixMode        (GL_PROJECTION);
    glLoadIdentity      ();
    //InitPerspective     (60.f, aspect, 0.1f, 1000.f);
    
    glMatrixMode        (GL_MODELVIEW);
    glLoadIdentity      ();
    
    
    glEnable           (GL_CULL_FACE);
    //glDisable            (GL_BLEND);
    glEnable            (GL_DEPTH_TEST);
    //glEnable            (GL_LIGHTING);
    //glEnableClientState (GL_NORMAL_ARRAY);
    
    //glEnable(GL_NORMALIZE);    
}

@implementation MQES1Renderer

@synthesize color_bg;
@synthesize mode;

// Create an OpenGL ES 1.1 context
- (id)init
{
    if ((self = [super init]))
    {
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];

        if (!context || ![EAGLContext setCurrentContext:context])
        {
            [self release];
            return nil;
        }

        // Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
        glGenFramebuffersOES(1, &defaultFramebuffer);
        glGenRenderbuffersOES(1, &colorRenderbuffer);
        glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);

		glEnable(GL_TEXTURE_2D);
		//texture_ground = [[Texture2D alloc] initWithImage:[UIImage imageNamed:@"texture_card0.png"]];

		//	gravity
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:k_acc_resolution];
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];

		color_bg = [UIColor whiteColor];
		mode = 0;
    }

    return self;
}

- (void)enable_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)disable_accelerometer
{
	[[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

- (void)set_image:(UIImage*)image
{
	CGSize size;
	if (is_phone())
		size = CGSizeMake(256, 256);
	else
		size = CGSizeMake(512, 512);
	[texture_ground release];
	texture_ground = [[Texture2D alloc] initWithImage:[image image_with_size_aspect:size]];
	[self render];
	//	NSLog(@"image: %@", texture_ground);
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	//	NSLog(@"accel:	%f,	%f,	%f", current_acc.x, current_acc.y, current_acc.z);
	accel[0] = acceleration.x * kFilteringFactor + accel[0] * (1.0 - kFilteringFactor);
	accel[1] = acceleration.y * kFilteringFactor + accel[1] * (1.0 - kFilteringFactor);
	accel[2] = acceleration.z * kFilteringFactor + accel[2] * (1.0 - kFilteringFactor);
}

- (void)render
{
#if 0
	static const GLfloat square_ground[] = {
		-1.0,  -1.0,  1.0,				// Top left
		-1.0,  -1.0, -1.0,				// Bottom left
		 1.0,  -1.0, -1.0,				// Bottom right
		 1.0,  -1.0,  1.0				// Top right
	};
#endif
	static const GLfloat square_ground[] = {
		-1.0,   1.0, -0.0,				// Top left
		-1.0,  -1.0, -0.0,				// Bottom left
		 1.0,  -1.0, -0.0,				// Bottom right
		 1.0,   1.0, -0.0				// Top right
	};
	GLshort square_texture_coords[] = { 1, 0, 1, 1, 0, 1, 0, 0 };
#if 0
	static const GLfloat triangleVertices[] = {
		0.0, 1.0, -6.0,                    // Triangle top centre
		-1.0, -1.0, -6.0,                  // bottom left
		1.0, -1.0, -6.0                    // bottom right
	};
#endif
    //static float transY = 0.0f;
	//GLfloat f;
	GLfloat	x, y, z;
	int i;

	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	glViewport(0, 0, backingWidth, backingHeight);

	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    //	glClearColor([color_bg get_red], [color_bg get_green], [color_bg get_blue], [color_bg get_alpha]);

#if 0
	glRotatef(5, 0.0, 0.0, 1.0);
    //glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
    transY += 0.05;
#endif

#if 0
	glVertexPointer(3, GL_FLOAT, 0, triangleVertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_TRIANGLES, 0, 3);
#endif

	glPushMatrix();
	{
		//	gravity
		for (i = 0; i < 3; i++)
		{
			if (accel[i] > 1)
				accel[i] = 1;
			if (accel[i] < -1)
				accel[i] = -1;
		}
		x = _rad_to_deg(asin(accel[0]));
		y = _rad_to_deg(asin(accel[1]));
		z = _rad_to_deg(asin(accel[2]));
		for (i = 0; i < 3; i++)
		{
			if (accel[i] >= 89.9)
				accel[i] = 89;
			if (accel[i] <= -89.9)
				accel[i] = 89;
		}
		//	NSLog(@"gravity: %f, %f, %f", x, y, z);
		//	glRotatef(-z, 1.0, 0.0, 0.0);
		//	glRotatef(+x, 0.0, 0.0, 1.0);
		switch (mode)
		{
			case 1:
				z = -z/1.75 - 10;
				break;
			case 2:
				z = z;
				break;
			case 3:
				z = -z - 10;
				break;
			default:
				z = -z - 90;
				break;
		}
		//	NSLog(@"gravity result: %f, %f, %f", x, y, z);
		glTranslatef(0.0, 0.0, -1.0);
#if TARGET_IPHONE_SIMULATOR
		static CGFloat sim_x, sim_z;
		sim_x += 0;
		sim_z += 1;
		glRotatef(sim_z, 1.0, 0.0, 0.0);
		glRotatef(sim_x, 0.0, 0.0, 1.0);
#else
		glRotatef(z, 1.0, 0.0, 0.0);
		glRotatef(+x, 0.0, 0.0, 1.0);
#endif
		glScalef(0.35, 0.35, 1.0);

		//glColor4f(0.0f,1.0f,0.0f,1.0f);
		glBindTexture(GL_TEXTURE_2D, texture_ground.name);

		//glColor4f(1.0f,0.0f,0.0f,1.0f);
		glVertexPointer(3, GL_FLOAT, 0, square_ground);
		glEnableClientState(GL_VERTEX_ARRAY);
		glTexCoordPointer(2, GL_SHORT, 0, square_texture_coords);     // texture
		glEnableClientState(GL_TEXTURE_COORD_ARRAY);                  // texture
		glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
		glDisableClientState(GL_TEXTURE_COORD_ARRAY);                 // texture
	}
	glPopMatrix();

	// Replace the implementation of this method to do your own custom drawing
#if 0
	static const GLfloat squareVertices[] = {
        -0.5f,  -0.33f,
         0.5f,  -0.33f,
        -0.5f,   0.33f,
         0.5f,   0.33f,
    };

    static const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };

    static float transY = 0.0f;

    // This application only creates a single context which is already set current at this point.
    // This call is redundant, but needed if dealing with multiple contexts.
    [EAGLContext setCurrentContext:context];

    // This application only creates a single default framebuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    glTranslatef(0.0f, (GLfloat)(sinf(transY)/2.0f), 0.0f);
    transY += 0.075f;

    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);

    glVertexPointer(2, GL_FLOAT, 0, squareVertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, squareColors);
    glEnableClientState(GL_COLOR_ARRAY);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
#endif
	[self draw_image_bg];

    // This application only creates a single color renderbuffer which is already bound at this point.
    // This call is redundant, but needed if dealing with multiple renderbuffers.
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)draw_image_bg
{
#if 0
	GLfloat X = 0;
	GLfloat Y = 0;
	GLfloat Z = 0;
	GLfloat W = 100;
	GLfloat H = 100;

	glBindTexture(GL_TEXTURE_2D, texture_ground.name);
 
	GLfloat box[] = {X,Y + H,Z,  X + W,Y + H,Z,     X + W, Y, Z,   X,Y,Z};
	GLfloat tex[] = {0,0, 1,0, 1,1, 0,1};
 
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
 
	glVertexPointer(3, GL_FLOAT, 0,box);
	glTexCoordPointer(2, GL_FLOAT, 0, tex);
 
	glDrawArrays(GL_QUADS,0,4);
 
	glDisableClientState(GL_VERTEX_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
#endif
}

- (BOOL)resizeFromLayer:(CAEAGLLayer *)layer
{	
    // Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);

    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
    {
        NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }

    return YES;
}

- (void)dealloc
{
    // Tear down GL
    if (defaultFramebuffer)
    {
        glDeleteFramebuffersOES(1, &defaultFramebuffer);
        defaultFramebuffer = 0;
    }

    if (colorRenderbuffer)
    {
        glDeleteRenderbuffersOES(1, &colorRenderbuffer);
        colorRenderbuffer = 0;
    }

    // Tear down context
    if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];

    [context release];
    context = nil;

    [super dealloc];
}

@end
