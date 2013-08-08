unless window.regel
  window.regel = {}
class regel.MitarbeiterController extends Spine.Controller

  constructor: (options)->
    super(options)

  render: () ->
    html = JST["regel/views/mitarbeiter"](@item)
    @replace(html)
    @