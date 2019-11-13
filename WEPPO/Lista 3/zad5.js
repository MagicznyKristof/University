var sum = function(){ 
    let result = 0;
    for( var arg of arguments){
        result += arg;
    }
    return result;
}


console.log(sum(1));
console.log(sum(1,2,3,4,5));
console.log(sum(1,6,78));
console.log(sum(1003,326,14121,34564,5647685685));
