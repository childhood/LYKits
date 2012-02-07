//
//  CalculadorSS.m
//  CalculadorSS
//
//  License / Licencia
//  ==================
//
//  Calculador SS by Rafa López is licensed under a Creative Commons Attribution 3.0 Unported License.
//
//  http://creativecommons.org/licenses/by/3.0/
//

#import "CalculadorSS.h"


@implementation CalculadorSS

@synthesize domingoResurreccion;
@synthesize miercolesCeniza;
@synthesize domingoRamos;
@synthesize domingoPentecostes;
@synthesize domingoTrinidad;
@synthesize juevesCorpus;
@synthesize domingoCorpus;

@synthesize strDomingoResurreccion;
@synthesize strMiercolesCeniza;
@synthesize strDomingoRamos;
@synthesize strDomingoPentecostes;
@synthesize strDomingoTrinidad;
@synthesize strJuevesCorpus;
@synthesize strDomingoCorpus;


- (id)init{
	// Inicializamos con el año en curso
	NSDate *hoy = [NSDate date];
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *componentes = [gregorian components: (NSYearCalendarUnit) fromDate:hoy];
	NSUInteger anioActual = [componentes year];
	[gregorian release];

	return [self initWithAnio:anioActual];
}

- (id)initWithAnio:(NSUInteger)valor{
	// Inicializamos con el año que nos pasen. Inicializador cualificado.
	if(self = [super init]){
		anio = valor;
		[self calcula];
	}
	return self;
}

- (void)calcula{
	// Algoritmo de Butcher para calcular la fecha del Domingo de Resurreción 
	// de un año dado del calendario gregoriano, que coincide con el primer
	// domingo tras la primera luna llena de primavera.
	// Condición necesaria y que no comprobamos dentro de la clase: 1582<año<2500
	
	NSUInteger A = anio % 19;
	NSUInteger B = anio / 100;
	NSUInteger C = anio % 100;
	NSUInteger D = B / 4;
	NSUInteger E = B % 4;
	NSUInteger F = (B + 8) / 25;
	NSUInteger G = (B - F + 1) / 3;
	NSUInteger H = ((19 * A) + B - D - G + 15) % 30;
	NSUInteger I = C / 4;
	NSUInteger K = C % 4;
	NSUInteger L = (32 + (2 * E) + (2 * I) - H - K) % 7;
	NSUInteger M = (A + (11 * H) + (22 * L)) / 451;
	NSUInteger P = H + L - (7 * M) + 114;
	
	NSDateComponents *componentes = [[NSDateComponents alloc] init];
	[componentes setDay:(NSUInteger)((P % 31) + 1)];
	[componentes setMonth:(NSUInteger)(P / 31)];
	[componentes setYear:(NSUInteger)anio];
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
	self.domingoResurreccion = [gregorian dateFromComponents: componentes];
	
	self.miercolesCeniza = [self fechaOffset:-46];
	self.domingoRamos = [self fechaOffset:-7];
	self.domingoPentecostes = [self fechaOffset:49];
	self.domingoTrinidad = [self fechaOffset:56];
	self.juevesCorpus = [self fechaOffset:60];
	self.domingoCorpus = [self fechaOffset:63];
	
	self.strMiercolesCeniza = [NSString stringWithFormat: @"Miércoles de Ceniza: %@",[self fecha2String:miercolesCeniza]];
	self.strDomingoRamos = [NSString stringWithFormat: @"Domingo de Ramos: %@",[self fecha2String:domingoRamos]];
	self.strDomingoResurreccion = [NSString stringWithFormat: @"Domingo de Resurrección: %@",[self fecha2String:domingoResurreccion]];
	self.strDomingoPentecostes = [NSString stringWithFormat: @"Domingo de Pentecostés: %@",[self fecha2String:domingoPentecostes]];
	self.strDomingoTrinidad = [NSString stringWithFormat: @"Domingo de la Trinidad: %@",[self fecha2String:domingoTrinidad]];
	self.strJuevesCorpus = [NSString stringWithFormat: @"Corpus Christi (Jue): %@",[self fecha2String:juevesCorpus]];
	self.strDomingoCorpus = [NSString stringWithFormat: @"Corpus Christi (Dom): %@",[self fecha2String:domingoCorpus]];
	
	[componentes release];
	[gregorian release];
}

- (NSDate *)fechaOffset:(int)offset{
	// Devuelve una fecha con un desplazamiento de offset días respecto al Domingo de Resurrección
	
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
	NSDateComponents *componentesOffset = [[NSDateComponents alloc] init];
	[componentesOffset setDay:(NSInteger) offset];
	NSDate *temp = [gregorian dateByAddingComponents:componentesOffset toDate:domingoResurreccion options:0];
	
	[gregorian release];
	[componentesOffset release];

	return temp;
}

- (NSString *)fecha2String:(NSDate *)fecha{
	// Devuelve una cadena con una fecha formateada
	
	NSDateFormatter *dateformatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateformatter setDateStyle:NSDateFormatterMediumStyle];
	[dateformatter setTimeStyle:NSDateFormatterNoStyle];
	
	return [dateformatter stringFromDate:fecha];
}

- (void)dealloc{
	[domingoResurreccion release];
	[miercolesCeniza release];
	[domingoRamos release];
	[domingoPentecostes release];
	[domingoTrinidad release];
	[juevesCorpus release];
	[domingoCorpus release];
		
	[strDomingoResurreccion release];
	[strMiercolesCeniza release];
	[strDomingoRamos release];
	[strDomingoPentecostes release];
	[strDomingoTrinidad release];
	[strJuevesCorpus release];
	[strDomingoCorpus release];
	
	[super dealloc];
}

@end