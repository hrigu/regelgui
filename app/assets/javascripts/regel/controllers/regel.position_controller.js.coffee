unless window.regel
  window.regel = {}


class regel.PositionController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".plot": "plot_element"

  constructor: (options)->
    super(options)

  render: () ->
    html = JST["regel/views/position"](@konfiguration)
    @replace(html)
    @

  initialize_grafik: () ->
    @slider.slider({
      min: 0,
      max: 100,
      range: "min",
      value: @konfiguration.gruenorangerot_position_100,
      slide: (event, ui) =>
        selector = "*[data-konfiguration_id =\"#{@konfiguration.id}\"] .slider_wert span"
        $(selector).text(ui.value)
        @redraw_plot(ui.value)
      stop: @update_value
    })

    @plot = $.plot(
      @plot_element, @values(@konfiguration.gruenorangerot_position_100)
        {
          xaxis: {
            max: 100
            ticks: [[0, "am Anfang"], [100, "am Schluss"]]
          }
          yaxis: {
            min: 0
            max: 5
            ticks: [] #keine
          }
        }
    )

  update_value: (event, ui) =>
    @konfiguration.updateAttribute("gruenorangerot_position_100", ui.value) # {ajax: false}

  redraw_plot: (current_value)->
    @plot.setData(@values(current_value))
    @plot.draw()

  values: (current_value) ->
    [ [[0, @konfiguration.start_value()], [current_value, @konfiguration.start_value()],[current_value, @konfiguration.end_value()], [100, @konfiguration.end_value()]]
    ]
