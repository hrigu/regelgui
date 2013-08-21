unless window.regel
  window.regel = {}


class regel.KonfigurationController extends Spine.Controller

  elements:
    ".mitarbeiterliste": "mitarbeiter_container"
    ".feedback": "feedback_element"
    ".btn-mitarbeiter-hinzufuegen": "btn_mitarbeiter_hinzufuegen"
    ".btn-mitarbeiter-hinzufuegen": "btn_mitarbeiter_hinzufuegen"
    ".konfiguration-value": "konfiguration_value"
  events:
    "click .btn-mitarbeiter-hinzufuegen": "toggle_alle_mitarbeiter_anzeigen"
    "click .btn-loeschen": "konfiguration_loeschen"


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

    @konfiguration.bind "error", (rec, msg) ->
      alert msg

    @konfiguration.bind "id_changed", (rec, other) =>
      _this.el.attr("data-konfiguration_id", rec.id)


  render: () ->
    html = JST["regel/views/konfiguration"](@konfiguration)
    @replace(html)
    @initialize_konfiguration_value()
    @initialize_mitarbeiter()
    @

  initialize_konfiguration_value: () ->
    graphik_controller = null
    if @konfiguration.type == regel.Konfiguration.POSITION_KONFIGURATION
      graphik_controller = new regel.PositionController(regel: @regel, konfiguration: @konfiguration)
    else
      graphik_controller = new regel.GruenOrangeRotController(regel: @regel, konfiguration: @konfiguration)
    graphik_controller.render()
    @konfiguration_value.html(graphik_controller.el)
    @graphik_controller = graphik_controller

  initialize_mitarbeiter: () ->
    @konfiguration.status = regel.Konfiguration.MITARBEITER_ANZEIGEN

    @mitarbeiter_controllers = []
    mitarbeiter = @regel.alle_mitarbeiter()
    for ma in mitarbeiter
      c = new regel.MitarbeiterController(regel: @regel, konfiguration: @konfiguration, mitarbeiter: ma)
      @mitarbeiter_controllers.push c
      c.render()
      @mitarbeiter_container.append(c.el)

  initialize_grafik: () ->
    @graphik_controller.initialize_grafik()



  release: () ->
    mc.release() for mc in @mitarbeiter_controllers
    @graphik_controller.release()
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
