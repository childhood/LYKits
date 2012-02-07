//
//  CalculadorSS.h
//  CalculadorSS
//
//  License / Licencia
//  ==================
//
//  Calculador SS by Rafa López is licensed under a Creative Commons Attribution 3.0 Unported License.
//
//  http://creativecommons.org/licenses/by/3.0/
//

#import <Foundation/Foundation.h>


@interface CalculadorSS : NSObject {
	NSUInteger anio;
	NSDate *domingoResurreccion, *miercolesCeniza, *domingoRamos, *domingoPentecostes, *domingoTrinidad, *juevesCorpus, *domingoCorpus;
	NSString *strDomingoResurreccion, *strMiercolesCeniza, *strDomingoRamos, *strDomingoPentecostes, *strDomingoTrinidad, *strJuevesCorpus, *strDomingoCorpus;
}

- (id)initWithAnio:(NSUInteger)valor;
- (void)calcula;
- (NSDate *)fechaOffset:(int)offset;
- (NSString *)fecha2String:(NSDate *)fecha;

@property (nonatomic,retain) NSDate *miercolesCeniza;
@property (nonatomic,retain) NSDate *domingoRamos;
@property (nonatomic,retain) NSDate *domingoResurreccion;
@property (nonatomic,retain) NSDate *domingoPentecostes;
@property (nonatomic,retain) NSDate *domingoTrinidad;
@property (nonatomic,retain) NSDate *juevesCorpus;
@property (nonatomic,retain) NSDate *domingoCorpus;

@property (nonatomic,copy) NSString *strMiercolesCeniza;
@property (nonatomic,copy) NSString *strDomingoRamos;
@property (nonatomic,copy) NSString *strDomingoResurreccion;
@property (nonatomic,copy) NSString *strDomingoPentecostes;
@property (nonatomic,copy) NSString *strDomingoTrinidad;
@property (nonatomic,copy) NSString *strJuevesCorpus;
@property (nonatomic,copy) NSString *strDomingoCorpus;

@end
