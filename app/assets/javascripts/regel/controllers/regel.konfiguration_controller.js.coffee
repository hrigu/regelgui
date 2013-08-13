unless window.regel
  window.regel = {}


class regel.KonfigurationController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".mitarbeiterliste": "mitarbeiter_container"
    ".feedback": "feedback_element"
    ".btn-mitarbeiter-hinzufuegen": "btn_mitarbeiter_hinzufuegen"
    #".mitarbeiter": "alle_mitarbeiter"      geht nicht, da dynamisch erstellt
  events:
    "click .btn-mitarbeiter-hinzufuegen": "toggle_alle_mitarbeiter_anzeigen"
    "click .btn-loeschen": "konfiguration_loeschen"

  constructor: (options)->
    super(options)
    regel.PositionKonfiguration.bind "ajaxSuccess", (konfiguration, xhr) =>
      if konfiguration.id == @item.id
        #@feedback_element.show()
        @feedback_element.html("<div>gespeichert</div>")
        @feedback_element.fadeTo('slow', 0, () =>
          @feedback_element.empty()
          @feedback_element.fadeTo("fast", 1)
        );

  render: () ->
    html = JST["regel/views/#{@item.type_as_string().toLowerCase()}"](@item)
    @replace(html)
    @initialize_grafik()
    @initialize_mitarbeiter()
    @

  initialize_grafik: () ->
    @slider.slider({
      min: 0,
      max: 100,
      range: "min",
      value: @item.gruenorangerot_position_100,
#      slide: (event, ui) ->
#        $("#gruenorangerot_position_100_" + regel.id).text(ui.value)
      stop: (event, ui) =>
        @item.updateAttribute("gruenorangerot_position_100", ui.value) # {ajax: false}
    })

  initialize_mitarbeiter: () ->
    @item.status = regel.Konfiguration.MITARBEITER_ANZEIGEN

    @mitarbeiter_controllers = []
    mitarbeiter = @regel.alle_mitarbeiter()
    for ma in mitarbeiter
      c = new regel.MitarbeiterController(regel: @regel, konfiguration: @item, item: ma)
      @mitarbeiter_controllers.push c
      c.render()
      @mitarbeiter_container.append(c.el)

  release: () ->
    mc.release() for mc in @mitarbeiter_controllers
    super

  toggle_alle_mitarbeiter_anzeigen: () ->
    @item.toggle_status()
    if (@item.is_status_mitarbeiter_bearbeiten())
      this.mitarbeiter_container.children(".mitarbeiter").show()
      this.btn_mitarbeiter_hinzufuegen.text("Nur eigene Mitarbeitende anzeigen")
    else
      this.mitarbeiter_container.children(".mitarbeiter.frei").hide()
      this.mitarbeiter_container.children(".mitarbeiter.anderer-konfiguration-zugeordnet").hide()

      this.btn_mitarbeiter_hinzufuegen.text("Mitarbeitende hinzufügen")

  konfiguration_loeschen: ()->
    @item.destroy()
    #TODO die anderen Konfigurationen benachrichtigen, dass Mitarbeiter wieder frei sind.
    @release()