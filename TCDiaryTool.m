#import "TCDiaryTool.h"
#import "TCDiary.h"
#import "FMDB.h"
@implementation TCDiaryTool
static FMDatabaseQueue *_queue;
+ (void)initialize
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    NSString *path  = [documentFolderPath stringByAppendingPathComponent:@"Note.sqlite"];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:path];
    if (!isExist)
    {
        NSString *backupDbPath = [[NSBundle mainBundle]pathForResource:@"Note.sqlite" ofType:nil];
        [fm copyItemAtPath:backupDbPath toPath:path error:nil];
    }
    _queue = [FMDatabaseQueue databaseQueueWithPath:path];
}
+(NSMutableArray *)queryWithNote
{
    __block TCDiary * datanote;
    __block NSMutableArray *diaryArray = nil;
    [_queue inDatabase:^(FMDatabase *db)
     {
         diaryArray = [NSMutableArray array];
         FMResultSet *rs = nil;
         rs = [db executeQuery:@"select * from securitynote"];
         while (rs.next)
         {
             datanote = [[TCDiary alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.time = [rs stringForColumn:@"time"];
             datanote.weather = [rs stringForColumn:@"weather"];
             datanote.mood = [rs stringForColumn:@"mood"];
             [diaryArray addObject:datanote];
         }
     }];
    return diaryArray;
}
+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
      [db executeUpdate:@"delete from securitynote where ids = ?", [NSNumber numberWithInt:ids]];
     }];
}
+(void)insertNote:(TCDiary *)diaryNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into securitynote(title, content, time, weather, mood) values (?, ?, ?, ?, ?)",diaryNote.title, diaryNote.content, diaryNote.time, diaryNote.weather, diaryNote.mood];
     }];
}
+(TCDiary *)queryOneNote:(int)ids
{
    __block TCDiary * datanote;
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         rs = [db executeQuery:@"select * from securitynote where ids = ?",[NSNumber numberWithInt:ids]];
         while (rs.next)
         {
             datanote = [[TCDiary alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.time = [rs stringForColumn:@"time"];
             datanote.weather = [rs stringForColumn:@"weather"];
             datanote.mood = [rs stringForColumn:@"mood"];
         }
     }];
    return datanote;
}
+(void)updataNote:(TCDiary *)updataNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update securitynote set title = ? , content = ?, time = ?, weather = ? , mood = ? where ids = ? ;",updataNote.title, updataNote.content, updataNote.time, updataNote.weather, updataNote.mood, [NSNumber numberWithInt:updataNote.ids]];
     }];
}
@end
