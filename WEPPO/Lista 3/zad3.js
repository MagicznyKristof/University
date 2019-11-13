function forEach( a, f ) {
    for( var element of a){
        f(element);
    }
}
function map( a, f ) {
    result = [];
    for( var element of a){
        result.push( f(element) );
    }
    return result;
}
function filter( a, f ) {
    result = [];
    for( var element of a){
        if( f(element) ){ result.push( element );
            //console.log(element);
            //console.log(result);
        }
    }
    //console.log(result);
    return result;
}

var a = [1,2,3,4];
forEach( a, _ => { console.log( _ ); } );
// [1,2,3,4]
console.log(filter( a, _ => _ < 3 ));
// [1,2]
console.log(map( a, _ => _ * 2 ));
// [2,4,6,8]
