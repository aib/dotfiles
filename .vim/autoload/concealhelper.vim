function concealhelper#add_conceal(syntax_type, new_type, pattern, old_type, cchar)
	if !has('conceal')
		finish
	endif

	execute "syntax" a:syntax_type a:new_type a:pattern "conceal cchar=" . a:cchar

	execute "highlight link" a:new_type a:old_type
	execute "highlight! link Conceal" a:new_type
endfunction
