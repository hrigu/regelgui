unless window.regel
  window.regel = {}
#Namespace

###
  Controller für eine spezifische Regel
  @regel: Das regel.Regel Element
###
class regel.RegelController extends Spine.Controller

  elements:
    ".collapse": "collapse"
    ".konfigurationen": "konfigurationen"
    ".btn-toggle-status": "toggle_status_button"
    ".anzeige-anzahl-mitarbeiter": "anzeige_anzahl_mitarbeiter"

  events:
    "click .titel": "toggle_content"
    "show .collapse": "show_content"
    "hide .collapse": "release_content"
    "click .btn-toggle-status": "toggle_status"
    "click .btn-neue-onfiguration": "create_new_configuration"

  ###
  regel
  ###
  constructor: (options)->
    super(options)
    @konfiguration_controllers = []
    regel.PositionKonfiguration.bind 'create', @render_konfiguration

  render: () ->
    html = JST['regel/views/regel'](@regel)
    @replace(html)
    new regel.RegelAnzeigeAnzahlMitarbeiterController(el: @anzeige_anzahl_mitarbeiter, regel: @regel)
    @


  toggle_content: (arg) ->
    @collapse.collapse('toggle')

  toggle_status: (arg) ->
    @el.removeClass(@regel.status())
    @regel.toggle_status()
    @toggle_status_button.text(@regel.status_change_msg())
    @el.addClass(@regel.status())

  show_content: (arg) ->
    if $(arg.target).hasClass('collapse')   #Damit nicht der show event des popovers reinspielt
      @render_konfigurationen()

  create_new_configuration: (arg) ->
    options = {}
    c = new regel.NeueKonfigurationController(regel: @regel).render()
    $("#myModal").html(c.el)
    $("#myModal").modal("show")

  ###
  releases alle KonfigurationsController
  ###
  release_content: (arg) ->
    if $(arg.target).hasClass('collapse')   #Damit nicht der show event des popovers reinspielt
      for c in @konfiguration_controllers
        c.release()

  #private
  render_konfigurationen: () =>
    konfigurationen = @regel.konfigurationen()
    for konfiguration in konfigurationen
      @render_konfiguration(konfiguration)

  #private
  render_konfiguration:(konfiguration) =>
    if (konfiguration.regel().id == @regel.id)
      c = new regel.KonfigurationController(regel: @regel, konfiguration: konfiguration)
      @konfiguration_controllers.push c
      c.render()
      @konfigurationen.append(c.el)

  zeige_mitarbeiter_infos: () ->
    #alert "hi"