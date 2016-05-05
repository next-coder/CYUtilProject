//
//  CYSQLite.h
//  CYUtilProject
//
//  Created by HuangQiSheng on 12/2/15.
//  Copyright © 2015 Charry. All rights reserved.
//

#ifndef CYSQLite_h
#define CYSQLite_h

#define CYSQLITE_ERROR_DOMAIN       @"CYSqliteErrorDomain"

#define CYSQLITE_OK                 0
#define CYSQLITE_UNKNOWN            -1
#define CYSQLITE_PATH_ERROR         8840
#define CYSQLITE_SQL_ERROR          8841
#define CYSQLITE_NOT_OPENED         8842
#define CYSQLITE_STATEMENT_CLOSED   8843
#define CYSQLITE_STATEMENT_NOT_PREPARED 8844

#import "CYDatabase.h"
#import "CYPrepareStatement.h"
#import "CYResultSet.h"

#endif /* CYSQLite_h */
