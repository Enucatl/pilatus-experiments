---
---

$ ->
    $("span.label.label-info").each (i, element) ->
        file_name = $(element).data "src"
        d3.csv file_name,
            (d) ->
                pixel: parseInt d.pixel
                visibility: parseFloat d.visibility 
            , (error, data) ->
                if error?
                    console.warn error
                    return
                
                average_visibility = 100 * d3.mean data[230..1160], (d) -> d.visibility
                $(element).text "#{average_visibility.toFixed(2)} %"
