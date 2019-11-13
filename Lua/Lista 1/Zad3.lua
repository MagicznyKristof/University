
function prime_factorization ( n )
  printf factorize( n )
end


function factorize ( n )
  local tab = {}
  while n%2 == 0 do
    tab[#tab] = 2
    n = n/2
  end
  local factor = 3
  while n > 1 do
    if n%factor == 0 then
      tab[#tab] = factor
      n = n/factor
    else
      factor = factor + 2
    end
  end
  return tab
end

    
  
 factorize(5) 