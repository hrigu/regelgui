unless window.regel
  window.regel = {}
class regel.KonfigurationController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".mitarbeiterliste": "mitarbeiter_container"
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
    @initialize_mitarbeiter()
    @

  initialize_grafik: () ->
    @slider.slider({
      min: 0,
      max: 100,
      range: "min",
      value: @item.gruenorangerot_position_100,
#      slide: (event, ui) ->
#        $("#gruenorangerot_position_100_" + regel.id).text(ui.value)
      stop: (event, ui) =>
        @item.updateAttribute("gruenorangerot_position_100", ui.value) # {ajax: false}
    })

  initialize_mitarbeiter: () ->
    @mitarbeiter_controllers = []
    mitarbeiter = @item.mitarbeiter()
    for ma in mitarbeiter
      c = new regel.MitarbeiterController(item: ma)
      @mitarbeiter_controllers.push c
      c.render()
      @mitarbeiter_container.append(c.el)

  release :() ->
    mc.release() for mc in @mitarbeiter_controllers
    super