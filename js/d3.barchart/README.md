d3.barchart
==========

Example
-------

```coffeescript
plot = new d3.chart.Bar()
    .width width
    .height height
    .margin
        left: 0.10 * width
        top: 0
        bottom: 0.15 * height
        right: 0.05 * width
    .x_value (d) -> d.x
    .y_value (d) -> d.y

d3.json "data.json", (error, data) ->
    if error?
        console.warn error
        return
    
    d3.select "#plot"
        .datum data
        .call plot.draw
```

Depends on
----------

my [base chart component](https://github.com/Enucatl/d3.base.chart)

