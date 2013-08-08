unless window.regel
  window.regel = {}
class regel.KonfigurationController extends Spine.Controller

  constructor: (options)->
    super(options)

  render: () ->
    html = JST['regel/views/konfiguration'](@item)
    @replace(html)
    @
