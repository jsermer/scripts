#!/usr/bin/ksh
nim -o fix_query -a fix_query_flags="-c" 530spot_res| grep ":-:" | grep 5300-05
