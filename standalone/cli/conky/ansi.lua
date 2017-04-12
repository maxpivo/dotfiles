-- vim: ts=4 sw=4 noet ai cindent syntax=lua

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- Initialize ANSI

ansiEscape    = ""

-- Foreground ansiors
ansiFgBlack   = ansiEscape .. "[30m" 
ansiFgRed     = ansiEscape .. "[31m"   
ansiFgGreen   = ansiEscape .. "[32m"
ansiFgYellow  = ansiEscape .. "[33m" 
ansiFgBlue    = ansiEscape .. "[34m"  
ansiFgPurple  = ansiEscape .. "[35m"
ansiFgCyan    = ansiEscape .. "[36m"   
ansiFgWhite   = ansiEscape .. "[37m"

-- Background ansiors
ansiBgBlack   = ansiEscape .. "[40m"  
ansiBgRed     = ansiEscape .. "[41m"   
ansiBgGreen   = ansiEscape .. "[42m"
ansiBgYellow  = ansiEscape .. "[43m" 
ansiBgBlue    = ansiEscape .. "[44m"  
ansiBgPurple  = ansiEscape .. "[45m"
ansiBgCyan    = ansiEscape .. "[46m"   
ansiBgWhite   = ansiEscape .. "[47m"

-- Special Character Conditions
ansiBoldOn       = ansiEscape .. "[1m"   
ansiBoldOff      = ansiEscape .. "[22m"
ansiItalicsOn    = ansiEscape .. "[3m"
ansiItalicsOff   = ansiEscape .. "[23m"
ansiUnderlineOn  = ansiEscape .. "[4m"
ansiUnderlineOff = ansiEscape .. "[24m"
ansiInvertOn     = ansiEscape .. "[7m"    
ansiInvertOff    = ansiEscape .. "[27m"

-- Reset to default configuration
ansiReset     = ansiEscape .. "[0m"
