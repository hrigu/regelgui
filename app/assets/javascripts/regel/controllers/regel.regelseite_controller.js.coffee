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
    @status = new regel.Status(this)
    regel.Regel.bind 'refresh', @render_regeln

  render: () ->
    html = JST['regel/views/regelseite']()
    @append(html)


  render_regeln: (regeln) =>
    for r in regeln
      c = new regel.RegelController(regel: r)
      @regelliste.append(c.render().el)

    $(".regelliste").sortable({
      handle: 'i.icon-resize-vertical',
      cursor: 'move',
      update: (event, ui)->
        index = ui.item.index()
        r = regel.Regel.find(ui.item.data("id"))
        r.updateAttribute("sort_order_position", index)
    });


class regel.Status extends Spine.Module
  @extend Spine.Events

  constructor: (@regelseite_controller) ->
    @reg_fetched = false
    @konf_fetched = false
    @mit_fetched = false
    regel.Konfiguration.bind 'refresh', @konfigurationen_fetched
    regel.Mitarbeiter.bind 'refresh', @mitarbeiter_fetched
    regel.Regel.bind 'refresh', @regel_fetched

  regel_fetched:() =>
    @reg_fetched = true
    @trigger_if_all_fetched()

  konfigurationen_fetched:() =>
    @konf_fetched = true
    @trigger_if_all_fetched()

  mitarbeiter_fetched:() =>
    @mit_fetched = true
    @trigger_if_all_fetched()

  trigger_if_all_fetched: () ->
    if  @reg_fetched &&  @konf_fetched && @mit_fetched
      regel.Status.trigger("alle_daten_geladen")
