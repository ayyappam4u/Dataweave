var orderPayload= payload.members map ((item, index) -> {
    "name": item.name,
    "dob": item.dob as Date{format:"dd/MM/yyyy"} 
    
}) orderBy ($.dob )
output application/json
---
orderPayload[0] ++ {
    "diff": (daysBetween(orderPayload[0].dob, orderPayload[-1].dob))/365
}
