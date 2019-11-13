
function stringf( tab )
  if type( tab ) == 'table' then
    local str = '{'
    for i = 1, #tab do
      if type( tab[i] ) == 'table' then
        str = str..stringf( tab[i] )
      else
        str = str..tostring(tab[i])
      end
      if i < #tab then
        --str = str..'}'
      --else
        str = str..','
      end
    end
    --str = str..'}'
    return str..'}'
  else
    return tostring( tab )
  end
end

function printf( arg )
  print( stringf ( arg ))
end





function moveinto( tab1, i1, j1, tab2, i2 )
  local t = #tab2
  print(t)
  for i=#tab2+1, #tab2 + (j1 - i2 + 1) do
    tab2[i] = 1
  end
--  #tab2 = #tab2 + (j1 - i2 + 1)
  for i=1,i2 do
    tab2[t - i + (j1 - i1) + 2] = tab2[t - i + 1]
  end
  for i = 0,(j1-i1) do
    tab2[i2 + i] = tab1[i1 + i]
  end
  t = #tab2
  print(t)
  printf(tab2)
end
  
--[=[  
function moveinto( tab1, i1, j1, i2 )
  moveinto( tab1, i1, j1, tab1, i2 )
end
--]=]

tab2 = {1, nil, 3, 7, nil, 8}
moveinto( {3, 4, nil, 6, 7}, 2, 4, tab2, 4)
  
  
