unless window.regel
  window.regel = {}
#Namespace

###
  Der Hauptkontroller
###
class regel.RegelseiteController extends Spine.Controller

  elements:
    ".regelliste": "regelliste"

  constructor: (options)->
    super(options)
    regel.Regel.bind 'refresh', @render_regeln            # Nach jeder Aktion die Info neu rendern

  render: () ->
    html = JST['regel/views/regelseite']()
    @append(html)


  render_regeln: (regeln) =>
    for regel_item in regeln
      debugger
      c = new regel.RegelController(item: regel_item)
      @regelliste.append(c.render().el)

