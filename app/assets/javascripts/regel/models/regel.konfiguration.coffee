unless window.regel
  window.regel = {}

###
  Erweitert Spine.Module um die Möglichkeit, einer spezifischen Instanz Instanzmethoden dynamisch zuzuweisen.
###
regel.Module = {
  include: (obj) ->
    for key, value of obj
      @[key] = value
    this
}

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
    result

  validate: () ->
    msg = switch @auspraegung()
      when regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN, regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
        msg = "grün1 muss kleiner oder gleich orange1 sein" if @gruen1 > @orange1
        msg = "orange1 muss kleiner oder gleich rot1 sein" if @orange1 > @rot1
        msg
      when regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN, regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
        msg = "grün2 muss grösser oder gleich orange2 sein" if @gruen2 < @orange2
        msg = "orange2 muss grösser oder gleich rot2 sein" if @orange2 < @rot2
        msg
    msg
} # end module

regel.PositionKonfigurationModule = {
  name: () ->
    "PositionKonfiguration"

  auspraegung: () ->
    regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
}

###
Das Konfigurationsmodell
###
class regel.Konfiguration extends Spine.Model
  @configure "Konfiguration", "id", "name", "type", "gruenorangerot_position_100", "regel_id", "mitarbeiter_ids", "gruen1", "orange1", "rot1", "gruen2", "orange2", "rot2"
  @extend Spine.Model.Ajax
  @include regel.Module

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
      @include regel.PositionKonfigurationModule
    else
      @include regel.GruenOrangeRotKonfigurationModule

  @url: ->
    Routes.konfigurationen_path()

  url: (options)->
    Routes.konfiguration_path(@id)#"regel/#{@id}"

  changeID:(id_neu) ->
    old_id = @id
    super(id_neu)
    @trigger("id_changed", {old_id: old_id})


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