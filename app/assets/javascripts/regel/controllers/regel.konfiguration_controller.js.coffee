unless window.regel
  window.regel = {}
class regel.KonfigurationController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".feedback": "feedback_element"


  constructor: (options)->
    super(options)
    regel.PositionKonfiguration.bind "ajaxSuccess", (status, xhr) =>
      #@feedback_element.show()
      @feedback_element.html("<div>gespeichert</div>")
      @feedback_element.fadeTo('slow', 0, () =>
        @feedback_element.empty()
        @feedback_element.fadeTo("fast", 1)
      );


  render: () ->
    html = JST["regel/views/#{@item.type_as_string().toLowerCase()}"](@item)
    @replace(html)
    @initialize_grafik()
    @


  initialize_grafik: () ->
    @slider.slider({
      #regel_id: regel.id,
      min: 0,
      max: 100,
      range: "min",
      value: @item.gruenorangerot_position_100,
#      slide: (event, ui) ->
#        $("#gruenorangerot_position_100_" + regel.id).text(ui.value)
      stop: (event, ui) =>
        @item.updateAttribute("gruenorangerot_position_100", ui.value) # {ajax: false}
    })
