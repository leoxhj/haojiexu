# Mongo Note

TBD
  
# Query examples
1. query last document
`db.action_execution_d_b.find({}).sort({start_timestamp:-1}).limit(1)`
2. query with logical operator
`db.action_execution_d_b.find({$or: [ { start_timestamp: { $gte: 1514251905782270 } }, { end_timestamp: { $gte: 1514251905782270 } } ] })  `
3. query count
`db.action_execution_d_b.find({}).count()`



