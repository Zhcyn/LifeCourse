#import "TCSimpleNoteTool.h"
#import "TCSimpleNote.h"
#import "FMDB.h"
@implementation TCSimpleNoteTool
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
+(NSMutableArray *)queryWithSql
{
    __block TCSimpleNote * datanote;
    __block NSMutableArray *dictArray = nil;
    [_queue inDatabase:^(FMDatabase *db)
     {
        dictArray = [NSMutableArray array];
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select * from simplenote"];
        while (rs.next)
        {
            datanote = [[TCSimpleNote alloc]init];
            datanote.ids = [rs intForColumn:@"ids"];
            datanote.count = [rs intForColumn:@"count"];
        NSMutableArray * oneData = [[NSMutableArray alloc]init];
            for (int i = 0; i < datanote.count; i++)
            {
                [oneData addObject:[rs stringForColumnIndex:i+2]];
            }
        [datanote.datas addObject:oneData];
        [dictArray addObject:datanote];
        }
    }];
    return dictArray;
}
+ (void)upDateWithString:(NSString *)string forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_queue inDatabase:^(FMDatabase *db)
    {
        NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%ld = ? WHERE ids = %ld;",(long)[indexPath row],(long)[indexPath section]];
        [db executeUpdate:upDate,string];
    }];
}
+(void)insertDatas:(TCSimpleNote *)addNote
{
    [_queue inDatabase:^(FMDatabase *db)
     {
        FMResultSet *rs = nil;
        rs = [db executeQuery:@"select count(*) from simplenote"];
        int counts = 0;
        if (rs.next)
        {
            counts = [rs intForColumnIndex:0];
        }
        [rs close];
            for (int i = 0; i < addNote.count; i++)
            {
                if(i == 0)
                {
                NSString * upDate = [NSString stringWithFormat:@"insert into simplenote(ids, count, tc%d) values (?, ?, ?)",i];
                [db executeUpdate:upDate,[NSNumber numberWithInt:counts],[NSNumber numberWithInt:addNote.count], [addNote.datas objectAtIndex:0]];
                }
                else  
                {
                   NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;",i,counts];
                    [db executeUpdate:upDate,[addNote.datas objectAtIndex:i]];
                }
            }
        }];
}
+(void)deleteString:(TCSimpleNote *)deleteStr
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         NSMutableArray * counts = [deleteStr.datas objectAtIndex:0];
         deleteStr.count = (int)[counts count];
         if(deleteStr.count == 0)
         {
             [db executeUpdate:@"delete from simplenote where ids = ?", [NSNumber numberWithInt:deleteStr.ids]];
             FMResultSet *rs = nil;
             rs = [db executeQuery:@"select count(*) from simplenote"];
             int counts = 0;
             if (rs.next)
             {
                 counts = [rs intForColumnIndex:0];
             }
             [rs close];
             for (int i = 0; i < counts - deleteStr.ids ; i++)
             {
                 [db executeUpdate:@"update simplenote set ids = ? where ids = ?", [NSNumber numberWithInt:(deleteStr.ids + i)],[NSNumber numberWithInt:(deleteStr.ids + i + 1)]];
             }
         }
         else 
         {
             for (int i = 0; i < deleteStr.count; i++)
             {
                 if(i == 0)
                 {
                     NSString * upDate = [NSString stringWithFormat:@"update simplenote set count = ? , tc%d = ? where ids = %d;", i, deleteStr.ids];
                     [db executeUpdate:upDate,[NSNumber numberWithInt:deleteStr.count], [[deleteStr.datas objectAtIndex:0] objectAtIndex:i]];
                 }
                 else  
                 {
                     NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;", i, deleteStr.ids];
                     [db executeUpdate:upDate,[[deleteStr.datas objectAtIndex:0] objectAtIndex:i]];
                 }
             }
         }
     }];
}
+(void)upDateInsert:(TCSimpleNote *)upDateInsert
{
    [_queue inDatabase:^(FMDatabase *db)
     {
         for (int i = 0; i < upDateInsert.count; i++)
         {
             if(i == 0)
             {
                 NSString * upDate = [NSString stringWithFormat:@"update simplenote set count = ? , tc%d = ? where ids = %d ;",i,upDateInsert.ids];
                 [db executeUpdate:upDate,[NSNumber numberWithInt:upDateInsert.count],               [[upDateInsert.datas objectAtIndex:0]objectAtIndex:0]];
             }
             else  
             {
                 NSString * upDate = [NSString stringWithFormat:@"update simplenote set tc%d = ? where ids = %d;",i,upDateInsert.ids];
                 [db executeUpdate:upDate,[[upDateInsert.datas objectAtIndex:0]objectAtIndex:i]];
             }
         }
     }];
}
@end
