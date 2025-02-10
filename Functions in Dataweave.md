Common Dataweave functions:

Map: Iterates over an array and applies a transformation to each element.
%dw 2.0
output application/json
var arr = [1, 2, 3]
---
arr map ((item, index) -> item*2)

Output: [2,4,6]
=========================================================
2. Filter: Filters an array based on a given condition.

%dw 2.0
output application/json
var arr = [1, 2, 3]
---
arr filter ((item, index) -> item >= 2)

Output:
[2,3]
===========================================================
3. MapObject: Iterates over key-value pairs in an object and transforms them.

%dw 2.0
output application/json
var obj = { a: 1, b: 2, c: 3 }
---
obj mapObject ((value, key, index) -> (key): value*2 )

Output:
{
  "a": 2,
  "b": 4,
  "c": 6
}

===========================================================
4. FilterObject: function is used to filter key-value pairs from an object based on a given condition.

%dw 2.0
output application/json
var obj = { a: 5, b: 15, c: 8, d: 20 }
---
obj filterObject ((value, key, index) -> value>=8 )

Output:
{
  "b": 15,
  "c": 8,
  "d": 20
}

===========================================================
5. Selector (payload..keyname, payload.*keyname)

..keyname (Deep Search - Recursive)

%dw 2.0
output application/json
var data = {
  user: {
    name: "Alice",
    address: {
      city: "New York",
      country: "USA"
    }
  },
  company: {
    name: "Tech Corp",
    location: {
      city: "San Francisco",
      country: "USA"
    }
  }
}
---
data..city

Output:
[
  "New York",
  "San Francisco"
]
.*keyname (Direct Child Access)

%dw 2.0
output application/json
var data = {
  user: {
    name: "Alice",
    city: "New York",
    city: "New York2"
  },
  company: {
    name: "Tech Corp",
    city: "San Francisco"
  }
}
---
data.user.*city

Output:
[
  "New York",
  "New York2"
]

===========================================================
6. Parseurl: parses a URL string into its components like protocol, host, port, path, query parameters, and fragment.

%dw 2.0
output application/dw
import * from dw::core::URL
var urlVar = "https://dataweave.mulesoft.com/learn/dataweave/?q=123"

---
{
    "parse2": parseURI(urlVar)
}

Output:
{
  parse2: {
    isValid: true,
    raw: "https://dataweave.mulesoft.com/learn/dataweave/?q=123",
    host: "dataweave.mulesoft.com",
    authority: "dataweave.mulesoft.com",
    path: "/learn/dataweave/",
    query: "q=123",
    scheme: "https",
    isAbsolute: true,
    isOpaque: false
  }
}

===========================================================
7. Substitute value, If else, Match

%dw 2.0
output application/dw
import * from dw::core::URL
var exchangerate = 10
var sample = "HELLO"
---
{
    "substitue": "hello substitute $(sample)",
    "ifelse" : if(exchangerate>9) "true"  else "flase",
    "MatchCondition": sample match {
    case "HELLO" -> "HELLO"
    case 400 -> "Bad Request"
    case 404 -> "Not Found"
    case 500 -> "Internal Server Error"
    else -> "Unknown Status"
  }
}

Output:
{
  substitue: "hello substitute HELLO",
  ifelse: "true",
  MatchCondition: "HELLO"
}

===========================================================
8. JSON to XML and vice versa: To convert to xml we need root element

%dw 2.0
output application/xml
var jsonData = 
  {
    "id": 101,
    "name": "John Doe",
    "department": "IT"
  }
---
{root: jsonData}

Output:
<?xml version='1.0' encoding='UTF-8'?>
<root>
  <id>101</id>
  <name>John Doe</name>
  <department>IT</department>
</root>

===========================================================
9.OrderBy: Sorts an array/Object based on a specified field or value.

%dw 2.0
output application/json
var arr = [3, 1, 4, 2]
---
(arr orderBy ((item, index) -> item)) [-1 to 0]

output: [4,3,2,1]
%dw 2.0
output application/json
var obj = { a: 3, b: 1, c: 2 }
---
{"OrdeBy": obj orderBy ((value, key) -> value)}

Output: {
  "OrdeBy": {
    "b": 1,
    "c": 2,
    "a": 3
  }
}

===========================================================
10. DistinctBy, GroupBy, JoinBy, log, update

%dw 2.0
import * from dw::util::Values
output application/json
var arrList = [2,4,1,3,5,6,77,43,22,2,3,4]
var empList = [ {   "empID": 100,   "empName": "Chinna",    "empStatus": "A"},{   "empID": 100,   "empName": "Chinna",    "empStatus": "ADuplicate"},{   "empID": 101,   "empName": "Mark",  "empStatus": "I"},{   "empID": 102,   "empName": "John",  "empStatus": "I",},{   "empID": 103,   "empName": "Stehphen",  "empStatus": "A"}]

---
{
"DistinctArray": arrList distinctBy ((item, index) -> item),
"disticntBy" : empList distinctBy ((item, index) -> item.empName ),
"groupBy": empList groupBy ((item, index) -> item.empStatus ),
"joinBy": arrList joinBy  ',',
"log": log("INFO",arrList),
"update" : empList map (item, index) -> (
 item  update "empStatus" with "Updated"
)
}
Output:
{
  "DistinctArray": [2,4,1,3,5,6,77,43,22],
  "disticntBy": [
    {
      "empID": 100,
      "empName": "Chinna",
      "empStatus": "A"
    },
    {
      "empID": 101,
      "empName": "Mark",
      "empStatus": "I"
    },
    {
      "empID": 102,
      "empName": "John",
      "empStatus": "I"
    },
    {
      "empID": 103,
      "empName": "Stehphen",
      "empStatus": "A"
    }
  ],
  "groupBy": {
    "A": [
      {
        "empID": 100,
        "empName": "Chinna",
        "empStatus": "A"
      },
      {
        "empID": 103,
        "empName": "Stehphen",
        "empStatus": "A"
      }
    ],
    "ADuplicate": [
      {
        "empID": 100,
        "empName": "Chinna",
        "empStatus": "ADuplicate"
      }
    ],
    "I": [
      {
        "empID": 101,
        "empName": "Mark",
        "empStatus": "I"
      },
      {
        "empID": 102,
        "empName": "John",
        "empStatus": "I"
      }
    ]
  },
  "joinBy": "2,4,1,3,5,6,77,43,22,2,3,4",
  "log": [2,4,1,3,5,6,77,43,22,2,3,4],
  "update": [
    {
      "empID": 100,
      "empName": "Chinna",
      "empStatus": "Updated"
    },
    {
      "empID": 100,
      "empName": "Chinna",
      "empStatus": "Updated"
    },
    {
      "empID": 101,
      "empName": "Mark",
      "empStatus": "Updated"
    },
    {
      "empID": 102,
      "empName": "John",
      "empStatus": "Updated"
    },
    {
      "empID": 103,
      "empName": "Stehphen",
      "empStatus": "Updated"
    }
  ]
}

===========================================================
11. Pluck: Extracts values from an object into an array.

%dw 2.0
output application/json
var obj = { a: 1, b: 2, c: 3 }
---
obj pluck ((value, key, index) -> value)

Output:
[1,2,3]
