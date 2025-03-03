payload reduce ((item, accumulator) -> item ++ accumulator ) groupBy ($) mapObject ((value, key, index) -> (key): keysOf(value))
