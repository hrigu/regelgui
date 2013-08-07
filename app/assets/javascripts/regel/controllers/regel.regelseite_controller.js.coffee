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
    for regel in regeln
      html = JST['regel/views/regel_list_item'](regel)
      @regelliste.append(html)

