---
---

$ ->
    placeholder = "#efficiency"
    file_names = $(placeholder).data "src"
    width = $(placeholder).width()
    factor = 0.618
    height = width * factor

    line = new d3.chart.Line()
        .width width
        .height height
        .x_scale d3.scale.log()
        .y_scale d3.scale.log()
        .x_value (d) -> d.exposure
        .y_value (d) -> d.counts
        .margin {
            left: 100
            top: 20
            bottom: 100
            right: 100
            }

                
    axes = new d3.chart.Axes()
        .x_scale line.x_scale()
        .y_scale line.y_scale()
        .x_title "exposure (s)"
        .y_title "counts"

    axes.x_axis().ticks 4, d3.format ".1f"
    axes.y_axis().ticks 4, d3.format ",d"

    legend = new d3.chart.LineLegend()
        .color_scale line.color_scale()
        .width width

    pilatus_parser = (d) ->
        exposure: parseFloat d.exposure
        counts: parseFloat d.counts

    mythen_parser = (d) ->
        exposure: parseFloat d.exposure
        counts: 172 / 50 * parseFloat d.counts # account for different pixel size

    d3.csv file_names.mythen, mythen_parser, (error, mythen) ->
        if error?
            console.warn error
            return
        d3.csv file_names.pilatus, pilatus_parser, (error, pilatus) ->
            if error?
                console.warn error
                return
            
            line.x_scale().domain d3.extent pilatus, (d) -> d.exposure
            line.y_scale()
                .domain [10, 1.1 * d3.max pilatus, (d) -> d.counts]
                .nice()
            d3.select placeholder
                .datum [{name: "mythen", values: mythen},
                        {name: "pilatus", values: pilatus}]
                .call line.draw

            d3.select placeholder
                .select "svg"
                .select "g"
                .datum 1
                .call axes.draw
                .call legend.draw
