---
---

class d3.chart.Axes extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.x_axis = d3.svg.axis()
        @accessors.y_axis = d3.svg.axis()
        @accessors.x_title = "x"
        @accessors.y_title = "y"
        super

    _draw: (element, data, i) ->
        #
        # element should be the big group inside the svg already translated
        # with the margins to avoid code duplication
        #
        # convenience accessors
        x_scale = @x_scale()
        y_scale = @y_scale()
        x_axis = @x_axis()
        y_axis = @y_axis()
        x_title = @x_title()
        y_title = @y_title()

        x_axis
            .scale x_scale
            .orient "bottom"
        
        y_axis 
            .scale y_scale
            .orient "left"

        y_group = d3.select element
            .selectAll ".y.axis"
            .data [data]

        y_group
            .enter()
            .append "g"
            .classed "y axis", true

        y_group
            .call y_axis

        x_group = d3.select element
            .selectAll ".x.axis"
            .data [data]

        x_group
            .enter()
            .append "g"
            .classed "x axis", true

        x_group
            .attr "transform", "translate(0, #{y_scale.range()[0]})"
            .call x_axis

        x_label = d3.select element
            .select ".x.axis"
            .selectAll "text.label"
            .data [data]

        x_label
            .enter()
            .append "text"
            .classed "label", true

        x_label
            .attr "x", x_scale.range()[1]
            .attr "dy", "2.49em"
            .style "text-anchor", "end"
            .text x_title
        
        x_label
            .exit()
            .remove()

        y_label = d3.select element
            .select ".y.axis"
            .selectAll "text.label"
            .data [data]

        y_label
            .enter()
            .append "text"
            .classed "label", true

        y_label
            .attr "transform", "rotate(-90)"
            .style "text-anchor", "end"
            .attr "dy", "1em"
            .text y_title
        
        y_label
            .exit()
            .remove()

        x_group
            .exit()
            .remove()

        y_group
            .exit()
            .remove()
