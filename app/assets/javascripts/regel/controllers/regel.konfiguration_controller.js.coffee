unless window.regel
  window.regel = {}


class regel.KonfigurationController extends Spine.Controller

  elements:
    ".slider": "slider"
    ".mitarbeiterliste": "mitarbeiter_container"
    ".feedback": "feedback_element"
    ".btn-mitarbeiter-hinzufuegen": "btn_mitarbeiter_hinzufuegen"

  events:
    "click .btn-mitarbeiter-hinzufuegen": "mitarbeiter_auswahlfenster_oeffnen"

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
    @initialize_add_mitarbeiter_popover()
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
    @mitarbeiter_container.droppable({
      drop: @mitarbeiter_hinzufuegen
    })
    for ma in mitarbeiter
      c = new regel.MitarbeiterController(item: ma)
      @mitarbeiter_controllers.push c
      c.render()
      @mitarbeiter_container.append(c.el)

  initialize_add_mitarbeiter_popover: () ->
    @btn_mitarbeiter_hinzufuegen.popover(
      title: "Mitarbeiter"
      content: "replace"
      placement: "left"
      #container: "##{@el.attr('id')}"
      container: "#regelseite"
    )


  release: () ->
    mc.release() for mc in @mitarbeiter_controllers
    super

  show_popover :() ->

  mitarbeiter_auswahlfenster_oeffnen: () ->
    html = JST["regel/views/add_mitarbeiter_popover"](@item)
    $(".popover-content").html(html)
    $( ".draggable" ).draggable();
#    cc = "<div> hi</div>"
#    @mitarbeiter_container.popover(
#      {html: true, content: cc, placement: "left", trigger: "click", delay: {show: 500, hide: 0}}
#    )

  mitarbeiter_hinzufuegen:(event, ui) =>
    mitarbeiter_id = ui.draggable.data("mitarbeiter-id");
    @item.add_mitarbeiter(mitarbeiter_id)