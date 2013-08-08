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
  events:
    "click .titel": "toggle_content"
    "show .collapse": "show_content"
    "hide .collapse": "release_content"

  constructor: (options)->
    super(options)
    regel.Regel.bind 'refresh', @render_regeln            # Nach jeder Aktion die Info neu rendern

  render: () ->
    html = JST['regel/views/regel'](@item)
    @replace(html)
    @

  toggle_content: (arg) ->
    @collapse.collapse('toggle')

  show_content: (arg) ->
    @render_konfigurationen()

  release_content: (arg) ->
    for c in @konfiguration_kontroller
      c.release()

  #private
  render_konfigurationen: () =>
    @konfiguration_kontroller = []
    konfigurationen = @item.konfigurationen()
    for konfiguration in konfigurationen
      c = new regel.KonfigurationController(item: konfiguration)
      @konfiguration_kontroller.push c
      c.render()
      @konfigurationen.append(c.el)

