unless window.regel
  window.regel = {}
class regel.MitarbeiterController extends Spine.Controller

  events:
    "click div.content": "clicked" #TODO regelgui: Wie kann ich events direkt auf dem el registrieren?

  ###
  @regel
  @konfiguration
  @item (mitarbeiter)
  ###
  constructor: (options)->
    super(options)


  render: () ->
    html = JST["regel/views/mitarbeiter"]({konfiguration: @konfiguration, mitarbeiter: @item, css_class: @css_class})
    @replace(html)
    @el.hide() unless @el.hasClass("zugeordnet")
    @

  css_class: ()=>
    if @konfiguration.is_mitarbeiter_set(@item) then "zugeordnet" else "frei"


  clicked: (arg)->
    if @konfiguration.is_mitarbeiter_set(@item)
      @el.removeClass("zugeordnet").addClass("frei")
      @konfiguration.remove_mitarbeiter(@item)
    else
      @el.removeClass("frei").addClass("zugeordnet")
      @konfiguration.add_mitarbeiter(@item)
