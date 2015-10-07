" Tomorrow Night Eighties - Full Colour and 256 Colour
" http://chriskempson.com
"
" Hex colour conversion functions borrowed from the theme "Desert256""
" Default GUI Colours
let s:foreground = "cccaca"
let s:background = "1b1b1b"
let s:selection = "3e3b3b"
let s:line = "222222"
let s:comment = "8a8a8a"
let s:red = "cf7275"
let s:orange = "c59f6f"
let s:yellow = "edc472"
let s:green = "b1d68b"
let s:aqua = "8ab4be"
let s:blue = "94aad1"
let s:magenta = "c98dad"
let s:window = "222222"
let s:periwinkle = "c0d8fc"
let s:darkcolumn = "121212"
let s:addbg = "5f875f"
let s:addfg = "d7ffaf"

hi clear
syntax reset

let g:colors_name = "newy"

if has("gui_running") || &t_Co == 88 || &t_Co == 256
	" Returns an approximate grey index for the given grey level
	fun <SID>grey_number(x)
		if &t_Co == 88
			if a:x < 23
				return 0
			elseif a:x < 69
				return 1
			elseif a:x < 103
				return 2
			elseif a:x < 127
				return 3
			elseif a:x < 150
				return 4
			elseif a:x < 173
				return 5
			elseif a:x < 196
				return 6
			elseif a:x < 219
				return 7
			elseif a:x < 243
				return 8
			else
				return 9
			endif
		else
			if a:x < 14
				return 0
			else
				let l:n = (a:x - 8) / 10
				let l:m = (a:x - 8) % 10
				if l:m < 5
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual grey level represented by the grey index
	fun <SID>grey_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 46
			elseif a:n == 2
				return 92
			elseif a:n == 3
				return 115
			elseif a:n == 4
				return 139
			elseif a:n == 5
				return 162
			elseif a:n == 6
				return 185
			elseif a:n == 7
				return 208
			elseif a:n == 8
				return 231
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 8 + (a:n * 10)
			endif
		endif
	endfun

	" Returns the palette index for the given grey index
	fun <SID>grey_colour(n)
		if &t_Co == 88
			if a:n == 0
				return 16
			elseif a:n == 9
				return 79
			else
				return 79 + a:n
			endif
		else
			if a:n == 0
				return 16
			elseif a:n == 25
				return 231
			else
				return 231 + a:n
			endif
		endif
	endfun

	" Returns an approximate colour index for the given colour level
	fun <SID>rgb_number(x)
		if &t_Co == 88
			if a:x < 69
				return 0
			elseif a:x < 172
				return 1
			elseif a:x < 230
				return 2
			else
				return 3
			endif
		else
			if a:x < 75
				return 0
			else
				let l:n = (a:x - 55) / 40
				let l:m = (a:x - 55) % 40
				if l:m < 20
					return l:n
				else
					return l:n + 1
				endif
			endif
		endif
	endfun

	" Returns the actual colour level for the given colour index
	fun <SID>rgb_level(n)
		if &t_Co == 88
			if a:n == 0
				return 0
			elseif a:n == 1
				return 139
			elseif a:n == 2
				return 205
			else
				return 255
			endif
		else
			if a:n == 0
				return 0
			else
				return 55 + (a:n * 40)
			endif
		endif
	endfun

	" Returns the palette index for the given R/G/B colour indices
	fun <SID>rgb_colour(x, y, z)
		if &t_Co == 88
			return 16 + (a:x * 16) + (a:y * 4) + a:z
		else
			return 16 + (a:x * 36) + (a:y * 6) + a:z
		endif
	endfun

	" Returns the palette index to approximate the given R/G/B colour levels
	fun <SID>colour(r, g, b)
		" Get the closest grey
		let l:gx = <SID>grey_number(a:r)
		let l:gy = <SID>grey_number(a:g)
		let l:gz = <SID>grey_number(a:b)

		" Get the closest colour
		let l:x = <SID>rgb_number(a:r)
		let l:y = <SID>rgb_number(a:g)
		let l:z = <SID>rgb_number(a:b)

		if l:gx == l:gy && l:gy == l:gz
			" There are two possibilities
			let l:dgr = <SID>grey_level(l:gx) - a:r
			let l:dgg = <SID>grey_level(l:gy) - a:g
			let l:dgb = <SID>grey_level(l:gz) - a:b
			let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
			let l:dr = <SID>rgb_level(l:gx) - a:r
			let l:dg = <SID>rgb_level(l:gy) - a:g
			let l:db = <SID>rgb_level(l:gz) - a:b
			let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
			if l:dgrey < l:drgb
				" Use the grey
				return <SID>grey_colour(l:gx)
			else
				" Use the colour
				return <SID>rgb_colour(l:x, l:y, l:z)
			endif
		else
			" Only one possibility
			return <SID>rgb_colour(l:x, l:y, l:z)
		endif
	endfun

	" Returns the palette index to approximate the 'rrggbb' hex string
	fun <SID>rgb(rgb)
		let l:r = ("0x" . strpart(a:rgb, 0, 2)) + 0
		let l:g = ("0x" . strpart(a:rgb, 2, 2)) + 0
		let l:b = ("0x" . strpart(a:rgb, 4, 2)) + 0

		return <SID>colour(l:r, l:g, l:b)
	endfun

	" Sets the highlighting for the given group
	fun <SID>X(group, fg, bg, attr)
		if a:fg != ""
			exec "hi " . a:group . " guifg=#" . a:fg . " ctermfg=" . <SID>rgb(a:fg)
		endif
	"	if a:bg != ""
	"		exec "hi " . a:group . " guibg=#" . a:bg . " ctermbg=" . <SID>rgb(a:bg)
	"	endif
		if a:attr != ""
			exec "hi " . a:group . " gui=" . a:attr . " cterm=" . a:attr
		endif
	endfun

	" Vim Highlighting
	call <SID>X("Normal", s:foreground,"" , "")
	call <SID>X("LineNr", s:selection, s:darkcolumn, "")
	call <SID>X("NonText", s:selection, "", "")
	call <SID>X("SpecialKey", s:selection, "", "")
	call <SID>X("Search", s:background, s:yellow, "")
	call <SID>X("TabLine", s:comment, s:line, "reverse")
	call <SID>X("TabLineFill", s:foreground, s:line, "reverse")
	call <SID>X("StatusLine", s:comment, s:background, "reverse")
	call <SID>X("StatusLineNC", s:window, s:comment, "reverse")
	call <SID>X("VertSplit", s:window, s:window, "none")
	call <SID>X("Visual", "", s:selection, "")
	call <SID>X("Directory", s:blue, "", "")
	call <SID>X("ModeMsg", s:green, "", "")
	call <SID>X("MoreMsg", s:green, "", "")
	call <SID>X("Question", s:green, "", "")
	call <SID>X("WarningMsg", s:red, "", "")
	call <SID>X("MatchParen", "", s:selection, "")
	call <SID>X("Folded", s:comment, s:background, "")
	call <SID>X("FoldColumn", s:selection, s:background, "")
	if version >= 700
		call <SID>X("CursorLine", "", s:line, "none")
		call <SID>X("CursorLineNr", s:red, s:background, "none")
		call <SID>X("CursorColumn", "", s:line, "none")
		call <SID>X("PMenu", s:foreground, s:darkcolumn, "none")
		call <SID>X("PMenuSel", s:foreground, s:darkcolumn, "reverse")
		call <SID>X("SignColumn", "", s:background, "none")
	end
	if version >= 703
		call <SID>X("ColorColumn", "", s:line, "none")
	end

	" Standard Highlighting
	call <SID>X("Comment", s:comment, "", "")
	call <SID>X("Todo", s:comment, s:background, "")
	call <SID>X("Title", s:red, "", "")
	call <SID>X("Identifier", s:magenta, "", "none")
	call <SID>X("Statement", s:blue, "", "")
	"call <SID>X("Conditional", s:foreground, "", "")
	call <SID>X("StorageClass", s:orange, "", "")
	call <SID>X("Repeat", s:foreground, "", "")
	call <SID>X("Structure", s:magenta, "", "")
	call <SID>X("Function", s:yellow, "", "")
	call <SID>X("Constant", s:red, "", "")
	call <SID>X("Keyword", s:orange, "", "")
	call <SID>X("String", s:green, "", "")
	call <SID>X("Special", s:foreground, "", "")
	call <SID>X("PreProc", s:magenta, "", "")
	call <SID>X("Operator", s:aqua, "", "none")
	call <SID>X("Type", s:periwinkle, "", "none")
	call <SID>X("Define", s:magenta, "", "none")
	call <SID>X("Include", s:blue, "", "")
	"call <SID>X("Ignore", "666666", "", "")
	" Vim Highlighting
	call <SID>X("vimCommand", s:periwinkle, "", "none")
  " Java Specifics
  call <SID>X("javaType", s:yellow,"","none")
  call <SID>X("javaExternal", s:blue,"","none")
  call <SID>X("javaConditional", s:periwinkle,"","none")
  call <SID>X("javaExceptions", s:green,"","none")
  call <SID>X("javaScopeDecl", s:magenta,"","none")
  call <SID>X("javaStorageClass", s:orange, "",  "none")

	" C Highlighting
	call <SID>X("cType", s:yellow, "", "")
	call <SID>X("cStorageClass", s:magenta, "", "")
	call <SID>X("cConditional", s:magenta, "", "")
	call <SID>X("cRepeat", s:magenta, "", "")

	" PHP Highlighting
	call <SID>X("phpVarSelector", s:red, "", "")
	call <SID>X("phpKeyword", s:magenta, "", "")
	call <SID>X("phpRepeat", s:magenta, "", "")
	call <SID>X("phpConditional", s:magenta, "", "")
	call <SID>X("phpStatement", s:magenta, "", "")
	call <SID>X("phpMemberSelector", s:foreground, "", "")

	" Ruby Highlighting
	call <SID>X("rubySymbol", s:green, "", "")
	call <SID>X("rubyConstant", s:yellow, "", "")
	call <SID>X("rubyAccess", s:yellow, "", "")
	call <SID>X("rubyAttribute", s:blue, "", "")
	call <SID>X("rubyInclude", s:blue, "", "")
	call <SID>X("rubyLocalVariableOrMethod", s:orange, "", "")
	call <SID>X("rubyCurlyBlock", s:orange, "", "")
	call <SID>X("rubyStringDelimiter", s:green, "", "")
	call <SID>X("rubyInterpolationDelimiter", s:orange, "", "")
	call <SID>X("rubyConditional", s:magenta, "", "")
	call <SID>X("rubyRepeat", s:magenta, "", "")
	call <SID>X("rubyControl", s:magenta, "", "")
	call <SID>X("rubyException", s:magenta, "", "")

	" Crystal Highlighting
	call <SID>X("crystalSymbol", s:green, "", "")
	call <SID>X("crystalConstant", s:yellow, "", "")
	call <SID>X("crystalAccess", s:yellow, "", "")
	call <SID>X("crystalAttribute", s:blue, "", "")
	call <SID>X("crystalInclude", s:blue, "", "")
	call <SID>X("crystalLocalVariableOrMethod", s:orange, "", "")
	call <SID>X("crystalCurlyBlock", s:orange, "", "")
	call <SID>X("crystalStringDelimiter", s:green, "", "")
	call <SID>X("crystalInterpolationDelimiter", s:orange, "", "")
	call <SID>X("crystalConditional", s:magenta, "", "")
	call <SID>X("crystalRepeat", s:magenta, "", "")
	call <SID>X("crystalControl", s:magenta, "", "")
	call <SID>X("crystalException", s:magenta, "", "")

	" Python Highlighting
	call <SID>X("pythonInclude", s:magenta, "", "")
	call <SID>X("pythonStatement", s:magenta, "", "")
	call <SID>X("pythonConditional", s:magenta, "", "")
	call <SID>X("pythonRepeat", s:magenta, "", "")
	call <SID>X("pythonException", s:magenta, "", "")
	call <SID>X("pythonFunction", s:blue, "", "")
	call <SID>X("pythonPreCondit", s:magenta, "", "")
	call <SID>X("pythonRepeat", s:aqua, "", "")
	call <SID>X("pythonExClass", s:orange, "", "")

	" JavaScript Highlighting
	call <SID>X("javaScriptBraces", s:foreground, "", "")
	call <SID>X("javaScriptFunction", s:magenta, "", "")
	call <SID>X("javaScriptConditional", s:magenta, "", "")
	call <SID>X("javaScriptRepeat", s:magenta, "", "")
	call <SID>X("javaScriptNumber", s:orange, "", "")
	call <SID>X("javaScriptMember", s:orange, "", "")
	call <SID>X("javascriptNull", s:orange, "", "")
	call <SID>X("javascriptGlobal", s:blue, "", "")
	call <SID>X("javascriptStatement", s:red, "", "")

	" CoffeeScript Highlighting
	call <SID>X("coffeeRepeat", s:magenta, "", "")
	call <SID>X("coffeeConditional", s:magenta, "", "")
	call <SID>X("coffeeKeyword", s:magenta, "", "")
	call <SID>X("coffeeObject", s:yellow, "", "")

	" HTML Highlighting
	call <SID>X("htmlTag", s:red, "", "")
	call <SID>X("htmlTagName", s:red, "", "")
	call <SID>X("htmlArg", s:red, "", "")
	call <SID>X("htmlScriptTag", s:red, "", "")

	" Diff Highlighting
	call <SID>X("diffAdd", "", "4c4e39", "")
	call <SID>X("diffDelete", s:background, s:red, "")
	call <SID>X("diffChange", "", "2B5B77", "")
	call <SID>X("diffText", s:line, s:blue, "")

	" ShowMarks Highlighting
	call <SID>X("ShowMarksHLl", s:orange, s:background, "none")
	call <SID>X("ShowMarksHLo", s:magenta, s:background, "none")
	call <SID>X("ShowMarksHLu", s:yellow, s:background, "none")
	call <SID>X("ShowMarksHLm", s:aqua, s:background, "none")

	" Lua Highlighting
	call <SID>X("luaStatement", s:magenta, "", "")
	call <SID>X("luaRepeat", s:magenta, "", "")
	call <SID>X("luaCondStart", s:magenta, "", "")
	call <SID>X("luaCondElseif", s:magenta, "", "")
	call <SID>X("luaCond", s:magenta, "", "")
	call <SID>X("luaCondEnd", s:magenta, "", "")

	" Cucumber Highlighting
	call <SID>X("cucumberGiven", s:blue, "", "")
	call <SID>X("cucumberGivenAnd", s:blue, "", "")

	" Go Highlighting
	call <SID>X("goDirective", s:magenta, "", "")
	call <SID>X("goDeclaration", s:magenta, "", "")
	call <SID>X("goStatement", s:magenta, "", "")
	call <SID>X("goConditional", s:magenta, "", "")
	call <SID>X("goConstants", s:orange, "", "")
	call <SID>X("goTodo", s:yellow, "", "")
	call <SID>X("goDeclType", s:blue, "", "")
	call <SID>X("goBuiltins", s:magenta, "", "")
	call <SID>X("goRepeat", s:magenta, "", "")
	call <SID>X("goLabel", s:magenta, "", "")

	" Clojure Highlighting
	call <SID>X("clojureConstant", s:orange, "", "")
	call <SID>X("clojureBoolean", s:orange, "", "")
	call <SID>X("clojureCharacter", s:orange, "", "")
	call <SID>X("clojureKeyword", s:green, "", "")
	call <SID>X("clojureNumber", s:orange, "", "")
	call <SID>X("clojureString", s:green, "", "")
	call <SID>X("clojureRegexp", s:green, "", "")
	call <SID>X("clojureParen", s:aqua, "", "")
	call <SID>X("clojureVariable", s:yellow, "", "")
	call <SID>X("clojureCond", s:blue, "", "")
	call <SID>X("clojureDefine", s:magenta, "", "")
	call <SID>X("clojureException", s:red, "", "")
	call <SID>X("clojureFunc", s:blue, "", "")
	call <SID>X("clojureMacro", s:blue, "", "")
	call <SID>X("clojureRepeat", s:blue, "", "")
	call <SID>X("clojureSpecial", s:magenta, "", "")
	call <SID>X("clojureQuote", s:blue, "", "")
	call <SID>X("clojureUnquote", s:blue, "", "")
	call <SID>X("clojureMeta", s:blue, "", "")
	call <SID>X("clojureDeref", s:blue, "", "")
	call <SID>X("clojureAnonArg", s:blue, "", "")
	call <SID>X("clojureRepeat", s:blue, "", "")
	call <SID>X("clojureDispatch", s:blue, "", "")

	" Scala Highlighting
	call <SID>X("scalaKeyword", s:magenta, "", "")
	call <SID>X("scalaKeywordModifier", s:magenta, "", "")
	call <SID>X("scalaOperator", s:blue, "", "")
	call <SID>X("scalaPackage", s:red, "", "")
	call <SID>X("scalaFqn", s:foreground, "", "")
	call <SID>X("scalaFqnSet", s:foreground, "", "")
	call <SID>X("scalaImport", s:magenta, "", "")
	call <SID>X("scalaBoolean", s:orange, "", "")
	call <SID>X("scalaDef", s:magenta, "", "")
	call <SID>X("scalaVal", s:magenta, "", "")
	call <SID>X("scalaVar", s:aqua, "", "")
	call <SID>X("scalaClass", s:magenta, "", "")
	call <SID>X("scalaObject", s:magenta, "", "")
	call <SID>X("scalaTrait", s:magenta, "", "")
	call <SID>X("scalaDefName", s:blue, "", "")
	call <SID>X("scalaValName", s:foreground, "", "")
	call <SID>X("scalaVarName", s:foreground, "", "")
	call <SID>X("scalaClassName", s:foreground, "", "")
	call <SID>X("scalaType", s:yellow, "", "")
	call <SID>X("scalaTypeSpecializer", s:yellow, "", "")
	call <SID>X("scalaAnnotation", s:orange, "", "")
	call <SID>X("scalaNumber", s:orange, "", "")
	call <SID>X("scalaDefSpecializer", s:yellow, "", "")
	call <SID>X("scalaClassSpecializer", s:yellow, "", "")
	call <SID>X("scalaBackTick", s:green, "", "")
	call <SID>X("scalaRoot", s:foreground, "", "")
	call <SID>X("scalaMethodCall", s:blue, "", "")
	call <SID>X("scalaCaseType", s:yellow, "", "")
	call <SID>X("scalaLineComment", s:comment, "", "")
	call <SID>X("scalaComment", s:comment, "", "")
	call <SID>X("scalaDocComment", s:comment, "", "")
	call <SID>X("scalaDocTags", s:comment, "", "")
	call <SID>X("scalaEmptyString", s:green, "", "")
	call <SID>X("scalaMultiLineString", s:green, "", "")
	call <SID>X("scalaUnicode", s:orange, "", "")
	call <SID>X("scalaString", s:green, "", "")
	call <SID>X("scalaStringEscape", s:green, "", "")
	call <SID>X("scalaSymbol", s:orange, "", "")
	call <SID>X("scalaChar", s:orange, "", "")
	call <SID>X("scalaXml", s:green, "", "")
	call <SID>X("scalaConstructorSpecializer", s:yellow, "", "")
	call <SID>X("scalaBackTick", s:blue, "", "")

	" Git
	call <SID>X("diffAdded", s:green, "", "")
	call <SID>X("diffRemoved", s:red, "", "")
	call <SID>X("gitcommitSummary", "", "", "bold")

	" Delete Functions
	delf <SID>X
	delf <SID>rgb
	delf <SID>colour
	delf <SID>rgb_colour
	delf <SID>rgb_level
	delf <SID>rgb_number
	delf <SID>grey_colour
	delf <SID>grey_level
	delf <SID>grey_number
endif
set background=dark
