#!/usr/bin/php56  
<?php 

# http://php.net/manual/en/function.popen.php

$path    = __dir__."/../assets";
$cmdin   = 'conky -c '.$path.'/conky.lua';
$cmdout  = 'less'; # or 'dzen2'
$cmd     = $cmdin.' | '.$cmdout;

# handle
$pipein  = popen($cmdin,  "r");
$pipeout = popen($cmdout, "w");

while(!feof($pipein)) {
    $buffer = fgets($pipein);
    fwrite($pipeout, $buffer);
    flush();
}

pclose($pipein);
pclose($pipeout);
