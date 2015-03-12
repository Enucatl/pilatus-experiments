---
---

class d3.chart.Colorbar extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.color_scale = d3.scale.linear()
        @accessors.orient = "vertical"
        @accessors.origin = {
            x: 0
            y: 0
        } # where on the parent should the colorbar appear?
        @accessors.barlength = 100
        @accessors.barthickness = 50
        super

    _draw: (element, data, i) ->

        # convenience accessors
        color_scale = @color_scale()
        margin = @margin()
        orient = @orient()
        origin = @origin()
        barlength = @barlength()
        barthickness = @barthickness()

        check_scale_type = ->
            # AFAIK, d3 scale types aren't easily accessible from the scale itself.
            # But we need to know the scale type for formatting axes properly
            cop = color_scale.copy()
            cop.range([0, 1])
            cop.domain([1, 10])
            if Math.abs((cop(10) - cop(1)) / Math.log(10) - (cop(10) - cop(2)) / Math.log(5)) < 1e-6
                return "log"
            else if Math.abs((cop(10) - cop(1)) / 9 - (cop(10) - cop(2)) / 8) < 1e-6
                return "linear"
            else if Math.abs((cop(10) - cop(1)) / (Math.sqrt(10) - 1) - (cop(10) - cop(2)) / (Math.sqrt(10) - Math.sqrt(2))) < 1e-6
                return "sqrt"
            else
                return "unknown"

        scale_type = check_scale_type()

        if orient is "horizontal"
            [margin.top, margin.bottom, margin.left, margin.right] = [margin.left, margin.right, margin.top, margin.bottom]
            thickness_attr = "height"
            length_attr = "width"
            axis_orient = "bottom"
            position_variable = "x"
            axis_transform = "translate (0, #{barthickness})"
        else
            thickness_attr = "width"
            length_attr = "height"
            axis_orient = "right"
            position_variable = "y"
            axis_transform = "translate (#{barthickness}, 0)"

        # select the svg if it exists
        svg = d3.select element
            .selectAll "svg.colorbar"
            .data [origin]

        # otherwise create the skeletal chart
        g_enter = svg.enter()
            .append "svg" 
            .classed "colorbar", true 
            .append "g" 
            .classed "colorbar", true 
        g_enter.append "g" 
            .classed "legend", true 
            .classed "rect", true 
        g_enter.append "g" 
            .classed "axis", true 
            .classed "color", true 

        svg
            .attr thickness_attr, barthickness + margin.left + margin.right 
            .attr length_attr, barlength + margin.top + margin.bottom 
            .style "margin-top", origin.y - margin.top + "px" 
            .style "margin-left", origin.x - margin.left + "px" 

        transitionDuration = 1000

        # This either creates, or updates, a fill legend, and drops it
        # on the screen.

        fillLegend = svg.select "g"
            .attr "transform", "translate(#{margin.left}, #{margin.top})" 
        fillLegendScale = color_scale.copy()

        legendRange = d3.range(
            0, barlength,
            barlength / (fillLegendScale.domain().length - 1))
        legendRange.push barlength 

        fillLegendScale.range legendRange.reverse() 

        colorScaleRects = fillLegend
            .select ".legend.rect" 
            .selectAll "rect" 
            .data d3.range(0, barlength) 

        colorScaleRects
            .enter()
            .append "rect" 
            .classed "legend", true 
            .style "opacity", 1 
            .style "stroke-thickness", 0 
            .transition()
            .duration transitionDuration 
            .attr thickness_attr, barthickness 
            .attr length_attr, 2  # single pixel thickness produces ghosting
            .attr position_variable, (d) -> d
            .style "fill", (d) -> color_scale fillLegendScale.invert d  

        colorScaleRects
            .exit()
            .remove()

        colorAxisFunction = d3.svg.axis()
            .scale fillLegendScale 
            .orient axis_orient 
            .ticks 5

        # Now make an axis
        fillLegend.selectAll ".color.axis" 
            .attr "transform", axis_transform 
            .call colorAxisFunction 
