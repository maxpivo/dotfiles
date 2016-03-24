Config { 

	-- appearance
		font =  "xft:Mono:size=9:bold:antialias=true"
		-- font = "-*-Fixed-Bold-R-Normal-*-13-*-*-*-*-*-*-*"
		, bgColor = "#000000"
		, fgColor = "#FFFFFF"
		, position = BottomW C 100
		, border =   TopB
		, borderColor =  "#646464"		

	-- layout		
		, sepChar = "%"
		, alignSep = "}{"
		, template = "%StdinReader% }{ <fc=#FD971F>[</fc>%mpd%<fc=#FD971F>]</fc> <fc=#dAA520>[</fc>%uname%<fc=#dAA520>]</fc> "
		
	-- plugins		
		, commands = [ 
			Run Com "mpc" [] "mpd" 10
			--Run MPD ["-t", "<state>: <artist> - <track>"] 10
			, Run Com "uname" ["-s","-r"] "uname" 36000
			, Run StdinReader
        ]

	}


