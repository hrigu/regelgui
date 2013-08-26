unless window.regel
  window.regel = {}


class regel.GruenOrangeRotController extends Spine.Controller

  elements:
    ".plot": "gruenorangerot_plot"
    ".input-fields .minimieren": "input_minimieren"
    ".input-fields .maximieren": "input_maximieren"
    #".mitarbeiter": "alle_mitarbeiter"      geht nicht, da dynamisch erstellt
  events:
    "change input": "update_gruenorangerot_field"


  constructor: (options)->
    super(options)

  render: () ->
    html = JST["regel/views/gruenorangerot"](@konfiguration)
    @replace(html)
    @input_minimieren.hide() if @konfiguration.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
    @input_maximieren.hide() if @konfiguration.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
    @

  ###
  Wird aufgerufen nach das gerenderte HTML dem DOM zugefügt wurde. Sonst hat der Container für den Plot noch keine Dimension
  ###
  initialize_grafik: () ->
    @plot = $.plot(
      @gruenorangerot_plot, @values()
      {
        xaxis: {
          max: 100
          ticks: [[0, "schlecht"], [33, "akzeptabel"], [66, "gut"], [100, "ideal"]]
        }
        yaxis: {
          min: 0
          max: @konfiguration.max_value() }
      }
    )


  update_gruenorangerot_field: (event) =>
    input = event.currentTarget
    property = input.attributes["data-property"].value
    value = parseInt(input.value)
    @konfiguration.updateAttribute(property, value)

    @redraw_plot()

  redraw_plot: ()->
    @plot.setData(@values())
    @plot.draw()

  values: () ->
    [ [[0, @konfiguration.max_value()], [33, @konfiguration.rot_untere_grenze], [66, @konfiguration.orange_untere_grenze], [100, @konfiguration.gruen_untere_grenze]],
      [[0, 0], [33, @konfiguration.rot_obere_grenze], [66, @konfiguration.orange_obere_grenze], [100, @konfiguration.gruen_obere_grenze]]
    ]
