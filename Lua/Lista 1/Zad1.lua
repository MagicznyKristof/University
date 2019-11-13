
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

printf({1, 2, 3})
printf({'to są', {}, {2, 'tablice'}, 'zagnieżdżone?', {true}})
printf({true})

function prime_factorization ( n )
  printf (factorize( n ))
end


function factorize ( n )
  local tab = {}
  local i = 1
  while n%2 == 0 do
    tab[i] = 2
    n = n/2
    i = i+1
  end
  local factor = 3
  while n > 1 do
    if n%factor == 0 then
      tab[i] = factor
      n = n/factor
      i=i+1
    else
      factor = factor + 2
    end
  end
  return tab
end

    
  
 prime_factorization(17539452) 