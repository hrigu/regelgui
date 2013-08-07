unless window.regel
  window.regel = {}
#Namespace

###
  Der Hauptkontroller
###
class regel.RegelController extends Spine.Controller

  events:
    "click .titel": "expand"

  constructor: (options)->
    super(options)
    regel.Regel.bind 'refresh', @render_regeln            # Nach jeder Aktion die Info neu rendern

  render: () ->
    html = JST['regel/views/regel_list_item'](@item)
    @replace(html)
    @

  expand: () ->
    alert @item.name
