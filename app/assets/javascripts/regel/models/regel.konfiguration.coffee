unless window.regel
  window.regel = {}


regel.GruenOrangeRotKonfigurationModule = {
  name: () ->
    "GruenOrangeRotKonfiguration"

  max_value: ()->
    x = Math.max [@gruen1, @orange1, @rot1, @gruen2, @orange2, @rot2]...
    x += 20
    x

  auspraegung: () ->
    result = switch
      when @gruen1 == null then regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
      when @gruen2 == null then regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
      else
        regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
}

regel.PositionKonfigurationModule = {
  name: () ->
    "PositionKonfiguration"

  auspraegung: () ->
    #TODO wie finde ich das raus?
    @AUSPRAEGUNG_MINIMIEREN
}

###
Das Konfigurationsmodell
###
class regel.Konfiguration extends Spine.Model
  @configure "Konfiguration", "id", "name", "type", "gruenorangerot_position_100", "regel_id", "mitarbeiter_ids", "gruen1", "orange1", "rot1", "gruen2", "orange2", "rot2"
  @extend Spine.Model.Ajax

  @MITARBEITER_ANZEIGEN = "mitarbeiter_anzeigen"
  @MITARBEITER_BEARBEITEN = "mitarbeiter_bearbeiten"

  @POSITION_KONFIGURATION = "PositionKonfiguration"
  @GRUENORANGEROT_KONFIGURATION = "GruenOrangeRotKonfiguration"

  @AUSPRAEGUNG_MAXIMIEREN = "maximieren" # Nur gruen1 orange1 und rot1 gesetzt
  @AUSPRAEGUNG_MINIMIEREN = "minimieren" # Nur gruen2 orange2 und rot2 gesetzt
  @AUSPRAEGUNG_EINSCHRAENKEN = "einschraenken" # Alle Werte gesetzt

  @KONFIGURATION_VARIANTEN = {
    position_konfiguration_maximieren: {konfiguration: @POSITION_KONFIGURATION, auspraegung: @AUSPRAEGUNG_MAXIMIEREN}
    position_konfiguration_minimieren: {konfiguration: @POSITION_KONFIGURATION, auspraegung: @AUSPRAEGUNG_MINIMIEREN}
    gruenorangerot_konfiguration_maximieren: {konfiguration: @GRUENORANGEROT_KONFIGURATION, auspraegung: @AUSPRAEGUNG_MAXIMIEREN}
    gruenorangerot_konfiguration_minimieren: {konfiguration: @GRUENORANGEROT_KONFIGURATION, auspraegung: @AUSPRAEGUNG_MINIMIEREN}
    gruenorangerot_konfiguration_einschraenken: {konfiguration: @GRUENORANGEROT_KONFIGURATION, auspraegung: @AUSPRAEGUNG_EINSCHRAENKEN}
  }

  constructor: ()->
    @status = regel.Konfiguration.MITARBEITER_ANZEIGEN
    super

    if @type == regel.Konfiguration.POSITION_KONFIGURATION
      regel.Konfiguration.include regel.PositionKonfigurationModule
    else
      regel.Konfiguration.include regel.GruenOrangeRotKonfigurationModule

  @url: ->
    Routes.konfigurationen_path()

  url: (options)->
    Routes.konfiguration_path(@id)#"regel/#{@id}"

  ###
  die gesetzten Mitarbeiter
  ###
  mitarbeiter: ->
    @mitarbeiter_ids.map (id) ->
      regel.Mitarbeiter.find(id)

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
  constructor: (args)->
    args.type = regel.Konfiguration.POSITION_KONFIGURATION
    super

class regel.GruenOrangeRotKonfiguration extends regel.Konfiguration
  constructor: (args)->
    args.type = regel.Konfiguration.GRUENORANGEROT_KONFIGURATION
    super
