unless window.regel
  window.regel = {}


class regel.KonfigurationController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".mitarbeiterliste": "mitarbeiter_container"
    ".feedback": "feedback_element"
    ".btn-mitarbeiter-hinzufuegen": "btn_mitarbeiter_hinzufuegen"
    ".gruenorangerot .plot": "gruenorangerot_plot"
    ".gruenorangerot .input-fields .minimieren": "input_minimieren"
    ".gruenorangerot .input-fields .maximieren": "input_maximieren"
    #".mitarbeiter": "alle_mitarbeiter"      geht nicht, da dynamisch erstellt
  events:
    "click .btn-mitarbeiter-hinzufuegen": "toggle_alle_mitarbeiter_anzeigen"
    "click .btn-loeschen": "konfiguration_loeschen"
    "change .gruenorangerot input": "update_gruenorangerot_field"


  constructor: (options)->
    super(options)
    regel.Konfiguration.bind "ajaxSuccess", (konfiguration, xhr) =>
      if konfiguration.id == @konfiguration.id
        #@feedback_element.show()
        @feedback_element.html("<div>gespeichert</div>")
        @feedback_element.fadeTo('slow', 0, () =>
          @feedback_element.empty()
          @feedback_element.fadeTo("fast", 1)
        );

  render: () ->
    html = JST["regel/views/konfiguration"](@konfiguration)
    @replace(html)
    @input_minimieren.hide() if @konfiguration.auspraegung() == regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
    @input_maximieren.hide() if @konfiguration.auspraegung() == regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
    @initialize_mitarbeiter()
    @

  ###
  Wird aufgerufen nach das gerenderte HTML dem DOM zugefügt wurde. Sonst hat der Container für den Plot noch keine Dimension
  ###
  initialize_grafik: () ->
    if @konfiguration.type == regel.Konfiguration.POSITION_KONFIGURATION
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
    else
      @plot = $.plot(
        @gruenorangerot_plot,
        [ [[0, @konfiguration.max_value()], [33, @konfiguration.rot1], [66, @konfiguration.orange1], [100, @konfiguration.gruen1]],
          [[0, 0], [33, @konfiguration.rot2], [66, @konfiguration.orange2], [100, @konfiguration.gruen2]]
        ],
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

  initialize_mitarbeiter: () ->
    @konfiguration.status = regel.Konfiguration.MITARBEITER_ANZEIGEN

    @mitarbeiter_controllers = []
    mitarbeiter = @regel.alle_mitarbeiter()
    for ma in mitarbeiter
      c = new regel.MitarbeiterController(regel: @regel, konfiguration: @konfiguration, mitarbeiter: ma)
      @mitarbeiter_controllers.push c
      c.render()
      @mitarbeiter_container.append(c.el)

  release: () ->
    mc.release() for mc in @mitarbeiter_controllers
    super

  toggle_alle_mitarbeiter_anzeigen: () ->
    @konfiguration.toggle_status()
    if (@konfiguration.is_status_mitarbeiter_bearbeiten())
      this.mitarbeiter_container.children(".mitarbeiter").show()
      this.btn_mitarbeiter_hinzufuegen.text("Nur eigene Mitarbeitende anzeigen")
    else
      this.mitarbeiter_container.children(".mitarbeiter.frei").hide()
      this.mitarbeiter_container.children(".mitarbeiter.anderer-konfiguration-zugeordnet").hide()

      this.btn_mitarbeiter_hinzufuegen.text("Mitarbeitende hinzufügen")

  konfiguration_loeschen: ()->
    @konfiguration.destroy()
    @release()


  update_gruenorangerot_field: (event) =>
    input = event.currentTarget
    property = input.attributes["data-property"].value
    value = parseInt(input.value)
    @konfiguration.updateAttribute(property, value)

    @redraw_plot()

  redraw_plot: ()->
    data = [
      [
        [0, @konfiguration.max_value()],
        [33, @konfiguration.rot1],
        [66, @konfiguration.orange1],
        [100, @konfiguration.gruen1]
      ],
      [
        [0, 0],
        [33, @konfiguration.rot2],
        [66, @konfiguration.orange2],
        [100, @konfiguration.gruen2]
      ]
    ]

    @plot.setData(data)
    @plot.draw()
