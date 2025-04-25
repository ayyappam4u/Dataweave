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
Input:

[{"Product": "Air Purifier","Location": "Delhi","order": [{"quarter": "1","units": 1200,"sales": 3000},{"quarter": "2","units": 1680,"sales": 3300},{"quarter": "3","units": 1100,"sales": 4200},{"quarter": "4","units": 2000,"sales": 1000}]},{"Product": "HairDryer","Location": "Hyderabad","order": [{"quarter": "1","units": 1000,"sales": 3400},{"quarter": "2","units": 800,"sales": 2000},{"quarter": "3","units": 1500,"sales": 4000},{"quarter": "4","units": 1560,"sales": 4600}]},{"Product": "Vaccum Cleaner","Location": "Delhi","order": [{"quarter": "1","units": 1000,"sales": 4500},{"quarter": "2","units": 1300,"sales": 4800},{"quarter": "3","units": 1450,"sales": 3000},{"quarter": "4","units": 540,"sales": 1300}]}]
*******************************
Script: 
payload groupBy ($.Location) pluck ((value, key, index) -> {
  Location: key,
  UnitsOrdered: sum((value.order) flatMap ((item, index) -> (item.units))),
  Stock: value groupBy ($.Product) pluck ((value1, key1, index) -> {
    (key1): {
      Avgstock: avg(value1.order flatMap ((item, index) -> (item.units))),
      Avgsales: avg(value1.order flatMap ((item, index) -> (item.sales)))
    }
  })
})
****************************
output:

[{"Location": "Delhi","UnitsOrdered": 10270,"Stock": [{"Air Purifier": {"Avgstock": 1495,"Avgsales": 2875}},{"Vaccum Cleaner": {"Avgstock": 1072.5,"Avgsales": 3400}}]},{"Location": "Hyderabad","UnitsOrdered": 4860,"Stock": [{"HairDryer": {"Avgstock": 1215,"Avgsales": 3500}}]}]

==============================================================================================================
Input: 
"yyyyMMddHHMMss"

Script:

var chars = payload splitBy  "" reduce ((item, acc = { currentGroup: "", groups: [] }) -> 
        if (acc.currentGroup == "" or item == acc.currentGroup[0]) 
            { 
                currentGroup: acc.currentGroup ++ item, 
                groups: acc.groups
            }
        else 
            { 
                currentGroup: item, 
                groups: (acc.groups + [acc.currentGroup]) 
            }
    )


---
(chars.groups + [chars.currentGroup]) map ((item, index) ->{

(item[0][0]): sizeOf(item[0])

} )

or

payload splitBy  /(?<=(.))(?!\1)/ map ((item, index) -> {

  (item[0]): sizeOf(item)
} )

********************************************************
Output:
[{"y": 4},{"M": 2},{"d": 2},{"H": 2},{"M": 2},{"s": 2}]
-------------------------------------------------------------------------------------------------

Prime:

%dw 2.0
var a =11
fun prime(a, range) = if(a <= 1) true else if(a ==2) false else (range map(a mod $) contains  0)
output application/json indent= false
---
//prime(a, 2 to a/2)

(0 to 500) filter(!prime($,2 to $/2))
-------------------------------------------------------------------------------------------------------
