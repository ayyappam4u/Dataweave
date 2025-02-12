-===============prime or not=========
%dw 2.0
output application/json
var arr = (2 to (payload.number/2))
var remainders = arr map (payload.number mod $)
---
if(payload.number == 2) "prime"  else if(remainders contains(0))"not prime"  else "prime"  


=================================================Factorial of number
%dw 2.0
output application/json
var arr = 1 to payload.number

---
arr reduce ($ * $$)
=========================================

=======================================Palindrome

%dw 2.0
import * from dw::core::Strings
output application/json
var arr = reverse(payload.message)

---
if(payload.message == arr) "Palindrome" else "not a palindrome"

======================================

%dw 2.0
var a = "20-02-2020"
output json
---
a as Date {format: "dd-MM-yyyy"} as String{format : "YYYY/dd/MM"}

===================
%dw 2.0
output json
var myInput = "name=Lansdowne Airport;lat=41.1304722; lon=-80.6195833;alt=1044; tz=-5;tzone=America/New_York"

---
splitBy(myInput, ";") reduce ((item, accumulator = {}) -> accumulator ++ {
    (splitBy(item, "=")[0]) : (splitBy(item, "=")[1])
})
===================
"193.32.10.20/24"
payload splitBy  (/[..\/]/) 
