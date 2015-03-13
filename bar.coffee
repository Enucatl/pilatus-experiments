class d3.chart.Bar extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.x_value = (d) -> d.x
        @accessors.y_value = (d) -> d.y
        super

    _draw: (element, data, i) ->
                 
        # convenience accessors
        width = @width()
        height = @height()
        margin = @margin()
        x_value = @x_value()
        y_value = @y_value()
        x_scale = @x_scale()
        y_scale = @y_scale()

        # update scales
        x_scale.range [0, width]
        y_scale.range [height, 0]

        # select the svg if it exists
        svg = d3.select element
            .selectAll "svg"
            .data [data]

        # otherwise create the skeletal chart
        g_enter = svg.enter()
            .append "svg"
            .append "g"

        # update the dimensions
        svg
            .attr "width", width + margin.left + margin.right
            .attr "height", height + margin.top + margin.bottom

        # update position
        g = svg.select "g"
            .attr "transform", "translate(#{margin.left}, #{margin.top})"

        g.selectAll "g.bars"
            .data [data]
            .enter()
            .append "g"
            .classed "bars", true

        bar_width = width / data.length

        bars = g.select "g.bars"
            .selectAll "rect"
            .data (d) -> d

        bars
            .enter()
            .append "rect"
            .classed "bar", true

        bars
            .attr "x", (d) -> x_scale x_value d
            .attr "y", (d) -> y_scale y_value d
            .attr "width", bar_width
            .attr "height", (d) -> height - y_scale y_value d

        bars
            .exit()
            .remove()
