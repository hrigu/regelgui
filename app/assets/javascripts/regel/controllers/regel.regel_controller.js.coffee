unless window.regel
  window.regel = {}
#Namespace

###
  Controller für eine spezifische Regel
  @this: Das regel.Regel Element
###
class regel.RegelController extends Spine.Controller

  elements:
    ".collapse": "collapse"
    ".konfigurationen": "konfigurationen"
    ".btn-toggle-status": "toggle_status_button"
  events:
    "click .titel": "toggle_content"
    "show .collapse": "show_content"
    "hide .collapse": "release_content"
    "click .btn-toggle-status": "toggle_status"

  constructor: (options)->
    super(options)
    regel.Regel.bind 'refresh', @render_regeln            # Nach jeder Aktion die Info neu rendern

  render: () ->
    html = JST['regel/views/regel'](@item)
    @replace(html)
    @

  toggle_content: (arg) ->
    @collapse.collapse('toggle')

  toggle_status: (arg) ->
    @el.removeClass(@item.status())
    @item.toggle_status()
    @toggle_status_button.text(@item.status_change_msg())
    @el.addClass(@item.status())



  show_content: (arg) ->
    @render_konfigurationen()

  ###
  released alle KonfigurationsController
  ###
  release_content: (arg) ->
    for c in @konfiguration_controllers
      c.release()

  #private
  render_konfigurationen: () =>
    @konfiguration_controllers = []
    konfigurationen = @item.konfigurationen()
    for konfiguration in konfigurationen
      c = new regel.KonfigurationController(item: konfiguration)
      @konfiguration_controllers.push c
      c.render()
      @konfigurationen.append(c.el)

