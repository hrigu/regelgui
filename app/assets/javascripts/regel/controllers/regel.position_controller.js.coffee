unless window.regel
  window.regel = {}


class regel.PositionController extends Spine.Controller

  elements:
    ".slider": "slider"

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
    #      slide: (event, ui) ->
    #        $("#gruenorangerot_position_100_" + regel.id).text(ui.value)
      stop: (event, ui) =>
        @konfiguration.updateAttribute("gruenorangerot_position_100", ui.value) # {ajax: false}
    })