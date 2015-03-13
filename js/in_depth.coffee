---
---

$ ->
    file_name = $("#absorption").data "src"
                
    d3.csv file_name,
        (d) ->
            pixel: parseInt d.pixel
            absorption: parseFloat d.absorption 
            differential_phase: parseFloat d.differential_phase 
            dark_field: parseFloat d.dark_field 
            visibility: parseFloat d.visibility 
            phase_stepping_curve: JSON.parse d.phase_stepping_curve 
            flat_phase_stepping_curve: JSON.parse d.flat_phase_stepping_curve 
        , (error, data) ->
            if error?
                console.warn error
                return
            
            create_image = (placeholder) ->
                column = $(placeholder).data "column"
                width = $(placeholder).width()
                original_width = 359
                original_height = 140
                factor = 2 * original_height / original_width
                height = width * factor

                image = new d3.chart.Image()
                    .width width
                    .height height
                    .original_width original_width
                    .original_height original_height
                    .color_value (d) -> d[column]
                    .margin {
                        left: 0
                        top: 0
                        bottom: 0
                        right: 0
                        }
                colorbar = new d3.chart.Colorbar()
                    .orient "horizontal"
                    .color_scale image.color_scale()
                    .barlength image.width()
                    .barthickness 0.1 * image.height()
                    .margin {
                        bottom: 0.1 * image.height()
                        left: 0
                        top: 0
                        right: 0
                        }

                sorted = data.map image.color_value()
                    .sort d3.ascending
                scale_min = d3.quantile sorted, 0.05
                scale_max = d3.quantile sorted, 0.95
                image.color_scale()
                    .domain [scale_min, scale_max]
                    .nice()
                d3.select placeholder
                    .datum data
                    .call image.draw
                d3.select placeholder
                    .datum [0]
                    .call colorbar.draw

            create_image "#absorption"
            create_image "#differential_phase"
            create_image "#dark_field"

        d3.csv $("#visibility_map").data("src"),
            (d) ->
                pixel: parseInt d.pixel
                visibility: parseFloat d.visibility
            , (error, data) ->
                if error?
                    console.warn error
                    return

                width = $("#visibility_map").width()
                factor = 0.618
                height = width * factor
                line = new d3.chart.Line()
                    .width width
                    .height height
                    .x_value (d) -> d.pixel
                    .y_value (d) -> d.visibility
                    .margin {
                        left: 50
                        top: 0
                        bottom: 50
                        right: 0
                        }

                line.x_scale().domain d3.extent data, (d) -> d.pixel
                line.y_scale().domain [0, 1.1 * d3.max data, (d) -> d.visibility]

                axes = new d3.chart.Axes()
                    .x_scale line.x_scale()
                    .y_scale line.y_scale()
                    .x_title "pixel"
                    .y_title "visibility"

                d3.select "#visibility_map"
                    .datum [
                        name: "visibility"
                        values: data
                    ]
                    .call line.draw

                d3.select "#visibility_map"
                    .select "svg"
                    .select "g"
                    .datum 1
                    .call axes.draw

                histogram = new d3.chart.Bar()
                    .width width
                    .height height
                    .margin {
                        left: 50
                        top: 0
                        bottom: 50
                        right: 0
                        }

                n_bins = 20
                histogram.x_scale().domain [
                    0.8 * d3.min data, (d) -> d.visibility
                    1.2 * d3.max data, (d) -> d.visibility
                ]

                histogram_data = d3.layout.histogram()
                    .bins(histogram.x_scale().ticks(n_bins))(
                        data.map (d) -> d.visibility)
                histogram.y_scale().domain [0, 1.1 * d3.max histogram_data, (d) -> d.y]

                histogram_axes = new d3.chart.Axes()
                    .x_scale histogram.x_scale()
                    .y_scale histogram.y_scale()
                    .x_title "visibility"
                    .y_title "#pixels"

                d3.select "#visibility_histogram"
                    .datum histogram_data
                    .call histogram.draw

                d3.select "#visibility_histogram"
                    .select "svg"
                    .select "g"
                    .datum 1
                    .call histogram_axes.draw

