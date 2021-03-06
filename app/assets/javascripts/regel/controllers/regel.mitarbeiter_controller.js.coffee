unless window.regel
  window.regel = {}
class regel.MitarbeiterController extends Spine.Controller

  events:
    "click div.content": "clicked" #TODO regelgui: Wie kann ich events direkt auf dem el registrieren?

  ###
  @regel
  @konfiguration
  @mitarbeiter (mitarbeiter)
  ###
  constructor: (options)->
    super(options)
    @mitarbeiter.bind("einer_konfiguration_hinzugefuegt", @mitarbeiter_wurde_einer_konfiguration_hinzugefuegt)
    @mitarbeiter.bind("einer_konfiguration_entfernt", @mitarbeiter_wurde_einer_konfiguration_entfernt)


  render: () ->
    html = JST["regel/views/mitarbeiter"]({konfiguration: @konfiguration, mitarbeiter: @mitarbeiter, css_class: @css_class})
    @replace(html)
    @el.hide() unless @el.hasClass("zugeordnet")
    @

  css_class: ()=>
    css_class = switch
      when @konfiguration.is_mitarbeiter_set(@mitarbeiter) then "zugeordnet"
      when @regel.is_mitarbeiter_set(@mitarbeiter) then "anderer-konfiguration-zugeordnet"
      else "frei"
    css_class


  clicked: (arg)->
    if @konfiguration.is_status_mitarbeiter_bearbeiten()
      if @konfiguration.is_mitarbeiter_set(@mitarbeiter)
        @el.removeClass("zugeordnet").addClass("frei")
        @konfiguration.remove_mitarbeiter(@mitarbeiter)
        @mitarbeiter.trigger("einer_konfiguration_entfernt", regel: @regel, konfiguration: @konfiguration)
      else if @el.hasClass("anderer-konfiguration-zugeordnet")
        @el.removeClass("anderer-konfiguration-zugeordnet").addClass("zugeordnet")
        @konfiguration.add_mitarbeiter(@mitarbeiter)
        @mitarbeiter.trigger("einer_konfiguration_hinzugefuegt", regel: @regel, konfiguration: @konfiguration)
      else
        @el.removeClass("frei").addClass("zugeordnet")
        @konfiguration.add_mitarbeiter(@mitarbeiter)
        @mitarbeiter.trigger("einer_konfiguration_hinzugefuegt", regel: @regel, konfiguration: @konfiguration)


  mitarbeiter_wurde_einer_konfiguration_hinzugefuegt: (mitarbeiter, sonst) =>
    if sonst.regel.id == @regel.id && sonst.konfiguration.id != @konfiguration.id
      if @el.hasClass("zugeordnet")
        @konfiguration.remove_mitarbeiter(@mitarbeiter) unless @konfiguration.destroyed # BUG: eigentlich sollte dieser Kontroller nicht mehr herumhängen, da er released wurde
      @el.removeClass("frei").removeClass("zugeordnet").addClass("anderer-konfiguration-zugeordnet")
      unless @konfiguration.is_status_mitarbeiter_bearbeiten()
        @el.hide()

  mitarbeiter_wurde_einer_konfiguration_entfernt: (mitarbeiter, sonst) =>
    #@log("this.regel.id = #{@regel.id}, this.konfiguration.id = #{@konfiguration.id}, geloescht: mitarbeiter.id = #{mitarbeiter.id}, geloescht von regel.id = #{sonst.regel.id}, geloescht von konfiguration.id = #{sonst.konfiguration.id}")
    if sonst.regel.id == @regel.id && sonst.konfiguration.id != @konfiguration.id
      @el.removeClass("frei").removeClass("anderer-konfiguration-zugeordnet").addClass("frei")
