#import <Foundation/Foundation.h>
@class TCSimpleNote;
@interface TCSimpleNoteTool : NSObject
+ (NSMutableArray *)queryWithSql;
+ (void)upDateWithString:(NSString*)string forRowAtIndexPath:(NSIndexPath *)indexPath;
+ (void)insertDatas:(TCSimpleNote *)addNote;
+ (void)deleteString:(TCSimpleNote *)deleteStr;
+ (void)upDateInsert:(TCSimpleNote *)upDateInsert;
@end
