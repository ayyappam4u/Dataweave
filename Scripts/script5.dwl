%dw 2.0
fun iterateObj(payload) = payload mapObject ((value, key, index) -> if(value is Object ) iterateObj(value mapObject ((v, k) -> {(key ++ "." ++ k): v})) else (key): value)
output application/xml
---

"EmployeeDetails": iterateObj(payload)
