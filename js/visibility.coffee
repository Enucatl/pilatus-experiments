---
---

$ ->
    average_visibility_element = $("#average-visibility")
    file_name = average_visibility_element.data "src"
    placeholder = "#visibility-map"

    width = $(placeholder).width()
    factor = 0.618
    height = width * factor

    line = new d3.chart.Line()
        .width width
        .height height
        .x_value (d) -> d.pixel
        .y_value (d) -> d.visibility

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
