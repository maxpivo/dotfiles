#!/usr/bin/php56  
<?php 

$timeformat = '%a %b %d %H:%M:%S';

do {
    print strftime($timeformat)."\n";
    sleep(1);
} while (true);
