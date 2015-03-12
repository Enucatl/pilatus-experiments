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
                factor = original_height / original_width
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

                sorted = data.map image.color_value()
                    .sort d3.ascending
                scale_min = d3.quantile sorted, 0.05
                scale_max = d3.quantile sorted, 0.95
                image.color_scale()
                    .domain [scale_min, scale_max]
                d3.select placeholder
                    .datum data
                    .call image.draw

            create_image "#absorption"
            create_image "#visibility"
            create_image "#differential_phase"
            create_image "#dark_field"
