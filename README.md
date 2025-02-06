# Dataweave

Input: {
 "employees": [
 {
 "name": "Alice",
 "department": "Sales",
 "location": "New York"
 },
 {
 "name": "Bob",
 "department": "Marketing",
 "location": "Chicago"
 },
 {
 "name": "Charlie",
 "department": "Sales",
 "location": "New York"
 }
 ]
}


**Expected output**
 {
  "location": {
    "New York": {
      "department": [
        {
          "Sales": [
            "Alice",
            "Charlie"
          ]
        }
      ]
    },
    "Chicago": {
      "department": [
        {
          "Marketing": [
            "Bob"
          ]
        }
      ]
    }
  }
}


**Script**

%dw 2.0
output application/json
---

 "location":payload.employees groupBy ($.location) mapObject ((value, key, index) ->{
   
    (key):
    "department": (value groupBy ($.department)) pluck ((value, key, index) ->(key): value.name )
} )

