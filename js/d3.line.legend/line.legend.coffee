class d3.chart.LineLegend extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.color_scale = d3.scale.category20()
        super

    _draw: (element, data, i) ->
                 
        width = $(element)[0].getBBox().width
        # convenience accessors
        color_scale = @color_scale()

        font_size = $(element).css('font-size')
        legend_element_height = Math.floor(parseInt(font_size.replace('px','')) * 1.5)
        legend_line_width = 0.05 * width

        legend_group = d3.select element
            .selectAll ".legends"
            .data [color_scale.domain()]

        legend_group
            .enter()
            .append "g"
            .classed "legends", true
            
        legend_group.exit().remove()

        legends = legend_group.selectAll ".legend"
            .data (d) -> d

        legends.enter()
            .append "g"
            .classed "legend", true

        legends.each (d) ->
            lines = d3.select this
                .selectAll "line"
                .data [d]

            lines
                .enter()
                .append "line"
                .classed "legend", true
                .attr "x1", width - legend_line_width
                .attr "x2", width
                .attr "y1", 0.5 * legend_element_height
                .attr "y2", 0.5 * legend_element_height
                .attr "stroke", color_scale

            lines.exit().remove()

            texts = d3.select this
                .selectAll "text"
                .data [d]

            texts
                .enter()
                .append "text"
                .attr "x", width - 1.2 * legend_line_width
                .attr "y", 0.5 * legend_element_height
                .attr "dy", 0.25 * legend_element_height
                .style "text-anchor", "end"
                .text (d) -> d

            texts.exit().remove()

        legends.attr "transform", (d, i) ->
            "translate(0, #{legend_element_height * i})"

        legends.exit().remove()
