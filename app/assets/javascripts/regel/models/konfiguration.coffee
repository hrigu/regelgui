unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Konfiguration extends Spine.Model

  @MITARBEITER_ANZEIGEN = "mitarbeiter_anzeigen"
  @MITARBEITER_BEARBEITEN = "mitarbeiter_bearbeiten"

  constructor: ()->
    @status = regel.Konfiguration.MITARBEITER_ANZEIGEN
    super


  type_as_string: () ->
    @constructor.name

  ###
  die gesetzten Mitarbeiter
  ###
  mitarbeiter: ->
    @mitarbeiter_ids.map (id) -> regel.Mitarbeiter.find(id)

  regel: ->
    regel.Regel.find(@regel_id)


  add_mitarbeiter: (mitarbeiter) ->
    @mitarbeiter_ids.push mitarbeiter.id
    @save()
    @regel().trigger("anzahl_mitarbeiter_geaendert")

  remove_mitarbeiter: (mitarbeiter) ->
    index = @mitarbeiter_ids.indexOf mitarbeiter.id
    @mitarbeiter_ids.splice(index, 1)
    @save()
    @regel().trigger("anzahl_mitarbeiter_geaendert")

  is_mitarbeiter_set: (m) ->
    for id in @mitarbeiter_ids
      return true if m.id == id
    false

   destroy: () ->
     debugger
     super
     @regel().trigger("anzahl_mitarbeiter_geaendert")
     m.trigger("einer_konfiguration_entfernt", regel: @regel(), konfiguration: @) for m in @mitarbeiter()


  toggle_status: () ->
    if(@status == regel.Konfiguration.MITARBEITER_BEARBEITEN)
      @status = regel.Konfiguration.MITARBEITER_ANZEIGEN
    else
      @status = regel.Konfiguration.MITARBEITER_BEARBEITEN

  is_status_mitarbeiter_bearbeiten: () ->
    @status == regel.Konfiguration.MITARBEITER_BEARBEITEN


class regel.PositionKonfiguration extends regel.Konfiguration
  @configure "PositionKonfiguration", "id", "name", "gruenorangerot_position_100", "regel_id", "mitarbeiter_ids"
  @extend Spine.Model.Ajax

  @url: ->
    Routes.position_konfigurationen_path()

  url: (options)->
    Routes.position_konfiguration_path(@id)#"regel/#{@id}"