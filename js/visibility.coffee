---
---

$ ->
    file_name = $("#visibility-map").data "src"
    placeholder = "#visibility-map"

    width = $(placeholder).width()
    factor = 0.618
    height = width * factor

    line = new d3.chart.Line()
        .width width
        .height height
        .x_value (d) -> d.pixel
        .y_value (d) -> d.visibility
        .margin {
            left: 100
            top: 20
            bottom: 100
            right: 100
            }

                
    axes = new d3.chart.Axes()
        .x_scale line.x_scale()
        .y_scale line.y_scale()
        .x_title "pixel"
        .y_title "visibility"

    d3.csv file_name,
        (d) ->
            pixel: parseInt d.pixel
            visibility: parseFloat d.visibility 
        , (error, data) ->
            if error?
                console.warn error
                return
            
            line.x_scale().domain d3.extent data, (d) -> d.pixel
            line.y_scale().domain [0, 1.1 * d3.max data, (d) -> d.visibility]
            d3.select placeholder
                .datum [
                    name: "visibility"
                    values: data
                ]
                .call line.draw

            d3.select placeholder
                .select "svg"
                .select "g"
                .datum 1
                .call axes.draw

