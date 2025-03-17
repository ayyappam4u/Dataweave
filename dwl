Input: inpt = 1  ht= 10

Script:
----------------------------------------------------------------------------------------------------------------
%dw 2.0
var inpt = 1
var ht= 10
var array = (inpt to ht ) ++ (ht to inpt)

fun formR(payload) = payload map((i) -> leftPad("", 10-i) ++ (1 to i *2 map ((item, index) -> 1 )joinBy  "" ) ++ rightPad("",10-i))

import * from dw::core::Strings
output application/json
---
 
formR(array)
-----------------------------------------------------------------------------------------------------------------

output: 
[
  "         11         ",
  "        1111        ",
  "       111111       ",
  "      11111111      ",
  "     1111111111     ",
  "    111111111111    ",
  "   11111111111111   ",
  "  1111111111111111  ",
  " 111111111111111111 ",
  "11111111111111111111",
  "11111111111111111111",
  " 111111111111111111 ",
  "  1111111111111111  ",
  "   11111111111111   ",
  "    111111111111    ",
  "     1111111111     ",
  "      11111111      ",
  "       111111       ",
  "        1111        ",
  "         11         "
]
=====================================================================================================================
Input: versions = ["2.8.6", "1.0.5", "1.6.09", "1.5.10"] 
 
Script:

  %dw 2.0
var versions = ["2.8.6", "1.0.5", "1.6.09", "1.5.10"]
output application/json
--- 
versions reduce ((item, ac = "0.0.0") -> do {
    var a = item splitBy "." map ((x) -> x as Number)
    var b = ac splitBy "." map ((x) -> x as Number)
    ---
    if (a[0] as Number > b[0] as Number) 
    
    item 
    else if((a[0] as Number == b[0] as Number) and (a[1] as Number > b[1] as Number) )
item
else if((a[0] as Number == b[0] as Number) and (a[1] as Number == b[1] as Number) and  (a[2] as Number > b[2] as Number))
    item
    else ac
})


    output: maximum value of versions
=========================================================================================================

{
    
    "a":5,
    "b":{
        "c": 9,
        "d": {
            "e":{
                "f": 10
            }
        }
    }
}



%dw 2.0
fun iterateObj(payload) = payload mapObject ((value, key, index) -> if(value is Object ) iterateObj(value mapObject ((v, k) -> {(key ++ "." ++ k): v})) else (key): value)
output application/json
---

iterateObj(payload)

========================================================================

[{
    "mule": "tool"
},
{
    "java": "prog"
}]
=
%dw 2.0
import * from dw::core::Arrays
var keys = ((payload map keysOf($))divideBy 2)
var values = ((payload map valuesOf($))divideBy 2)
output application/json
---
(keys ++ values) map ((item, index) -> {
    (item[0][0]): item[1][0]
})
===============================================================
%dw 2.0
import * from dw::core::Arrays

var a = [1,2,3,4,5]
output application/json
---
a map ((item, index) ->  sum(a[0 to index]))
=====================================================
  {
"orders": [

                                                                                                                                       
{ "orderId": "101", "customer": "Alice", "items": [ { "name": "Laptop", "price": 1200 }, { "name": "Mouse", "price": 20 } ] },
{ "orderId": "102", "customer": "Bob", "items": [ { "name": "Keyboard", "price": 50 }, { "name": "Monitor", "price": 300 } ] },

{ "orderId": "103", "customer": "Alice", "items": [ { "name": "Chair", "price": 150 } ] }
]
}

%dw 2.0
output application/json
---
customers:
payload.orders groupBy ($.customer) pluck ((value, key, index) ->{
name: value.customer[0],
totalSpent: sum(flatten(value.items).price)
} )
  ====================================================================
  %dw 2.0
var a = ["org20140909","org20150909","org20140809", "org20120609"]
output application/json
---
a orderBy ($[3 to 6]) groupBy ($[3 to 6]) mapObject ({
    "$$": $ map ((item, index) -> "ORG" ++ item[3 to -1] as Date{format:"yyyyMMdd"} )orderBy ($ )
} )
======================================================================

  
