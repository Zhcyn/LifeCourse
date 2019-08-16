#import "TCMemoTool.h"
#import "TCMemo.h"
#import "FMDB.h"
@implementation TCMemoTool
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
    __block TCMemo * datanote;
    __block NSMutableArray *memoArray = nil;
    [_queue inDatabase:^(FMDatabase *db)
     {
         memoArray = [NSMutableArray array];
         FMResultSet *rs = nil;
         rs = [db executeQuery:@"select * from memonote"];
         while (rs.next)
         {
             datanote = [[TCMemo alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.memotype = [rs stringForColumn:@"memotype"];
             datanote.year = [rs stringForColumn:@"year"];
             datanote.time = [rs stringForColumn:@"time"];
             [memoArray addObject:datanote];
         }
     }];
    return memoArray;
}
+(void)deleteNote:(int)ids
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"delete from memonote where ids = ?", [NSNumber numberWithInt:ids]];
     }];
}
+(void)insertNote:(TCMemo *)memoNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"insert into memonote(title, content, memotype, year, time) values (?, ?, ?, ?, ?)",memoNote.title, memoNote.content, memoNote.memotype, memoNote.year, memoNote.time];
     }];
}
+(TCMemo *)queryOneNote:(int)ids
{
    __block TCMemo * datanote;
    [_queue inDatabase:^(FMDatabase *db)
     {
         FMResultSet *rs = nil;
         rs = [db executeQuery:@"select * from memonote where ids = ?",[NSNumber numberWithInt:ids]];
         while (rs.next)
         {
             datanote = [[TCMemo alloc]init];
             datanote.ids = [rs intForColumn:@"ids"];
             datanote.title = [rs stringForColumn:@"title"];
             datanote.content = [rs stringForColumn:@"content"];
             datanote.memotype = [rs stringForColumn:@"memotype"];
             datanote.year = [rs stringForColumn:@"year"];
             datanote.time = [rs stringForColumn:@"time"];
         }
     }];
    return datanote;
}
+(void)updataNote:(TCMemo *)updataNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         [db executeUpdate:@"update memonote set title = ? , content = ?, memotype = ?, year = ? , time = ? where ids = ? ;",updataNote.title, updataNote.content, updataNote.memotype, updataNote.year, updataNote.time, [NSNumber numberWithInt:updataNote.ids]];
     }];
}
@end
