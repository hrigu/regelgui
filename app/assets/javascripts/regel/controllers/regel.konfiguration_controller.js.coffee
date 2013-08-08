unless window.regel
  window.regel = {}
class regel.KonfigurationController extends Spine.Controller

  elements:
    ".collapse": "collapse"
    ".accordion-inner": "regel_content"
  events:
    "click .titel": "expand"

  constructor: (options)->
    super(options)
    regel.Regel.bind 'refresh', @render_regeln            # Nach jeder Aktion die Info neu rendern

  render: () ->
    html = JST['regel/views/regel_list_item'](@item)
    @replace(html)
    @

  expand: (arg) ->
    debugger
    html = JST['regel/views/regel_content'](@item)
    @regel_content.html(html)
    @collapse.collapse('toggle')
