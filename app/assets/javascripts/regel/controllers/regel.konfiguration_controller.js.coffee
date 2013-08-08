unless window.regel
  window.regel = {}
class regel.KonfigurationController extends Spine.Controller

  constructor: (options)->
    super(options)

  render: () ->
    html = JST["regel/views/#{@item.type_as_string().toLowerCase()}"](@item)
    @replace(html)
    @
