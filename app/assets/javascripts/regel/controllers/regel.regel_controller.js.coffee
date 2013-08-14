unless window.regel
  window.regel = {}
#Namespace

###
  Controller für eine spezifische Regel
  @item: Das regel.Regel Element
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

  constructor: (options)->
    super(options)
    @konfiguration_controllers = []
    regel.PositionKonfiguration.bind 'create', @render_konfiguration

  render: () ->
    html = JST['regel/views/regel'](@item)
    @replace(html)
    new regel.RegelAnzeigeAnzahlMitarbeiterController(el: @anzeige_anzahl_mitarbeiter, regel: @item)
    @


  toggle_content: (arg) ->
    @collapse.collapse('toggle')

  toggle_status: (arg) ->
    @el.removeClass(@item.status())
    @item.toggle_status()
    @toggle_status_button.text(@item.status_change_msg())
    @el.addClass(@item.status())

  show_content: (arg) ->
    if $(arg.target).hasClass('collapse')   #Damit nicht der show event des popovers reinspielt
      @render_konfigurationen()

  create_new_configuration: (arg) ->
    options = {}
    c = new regel.NeueKonfigurationController(regel: @item)
    c.render()
    $("#myModal").html(c.el)
    $("#myModal").modal("show")

  ###
  released alle KonfigurationsController
  ###
  release_content: (arg) ->
    if $(arg.target).hasClass('collapse')   #Damit nicht der show event des popovers reinspielt
      for c in @konfiguration_controllers
        c.release()

  #private
  render_konfigurationen: () =>
    konfigurationen = @item.konfigurationen()
    for konfiguration in konfigurationen
      @render_konfiguration(konfiguration)

  #private
  render_konfiguration:(konfiguration) =>
    c = new regel.KonfigurationController(regel: @item, item: konfiguration)
    @konfiguration_controllers.push c
    c.render()
    @konfigurationen.append(c.el)

  zeige_mitarbeiter_infos: () ->
    #alert "hi"