%dw 2.0
output application/json
---

 "location":payload.employees groupBy ($.location) mapObject ((value, key, index) ->{
   
    (key):
    "department": (value groupBy ($.department)) pluck ((value, key, index) ->(key): value.name )
} )
