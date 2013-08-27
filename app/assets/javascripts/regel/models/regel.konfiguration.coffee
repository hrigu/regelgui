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

  max_value: ()->
    values = []
    if @auspraegung == regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN or  @auspraegung == regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
      values.push(@gruen_untere_grenze, @orange_untere_grenze, @rot_untere_grenze)
    if @auspraegung == regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN or  @auspraegung == regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
      values.push(@gruen_obere_grenze, @orange_obere_grenze, @rot_obere_grenze)
    x = Math.max values...
    x += 20
    x

  validate: () ->
    msgs = []
    switch @auspraegung
      when regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
        @validate_minimieren(msgs)
      when regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
        @validate_maximieren(msgs)
      when regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
        @validate_minimieren(msgs)
        @validate_maximieren(msgs)
        @validate_einschraenken(msgs)
    if msgs.length > 0 then msgs else null

  validate_minimieren: (msgs) ->
    msgs.push "grün_untere_grenze muss kleiner oder gleich orange_untere_grenze sein" if @gruen_untere_grenze > @orange_untere_grenze
    msgs.push "orange_untere_grenze muss kleiner oder gleich rot_untere_grenze sein" if @orange_untere_grenze > @rot_untere_grenze

  validate_maximieren: (msgs) ->
    msgs.push "grün_obere_grenze muss grösser oder gleich orange_obere_grenze sein" if @gruen_obere_grenze < @orange_obere_grenze
    msgs.push "orange_obere_grenze muss grösser oder gleich rot_obere_grenze sein" if @orange_obere_grenze < @rot_obere_grenze

  validate_einschraenken: (msgs) ->
    msgs.push "grün_untere_grenze muss grösser oder gleich grün_obere_grenze sein" if @gruen_untere_grenze < @gruen_obere_grenze
    msgs.push "orange_untere_grenze muss grösser oder gleich orange_obere_grenze sein" if @orange_untere_grenze < @orange_obere_grenze
    msgs.push "rot_untere_grenze muss grösser oder gleich rot_obere_grenze sein" if @rot_untere_grenze < @rot_obere_grenze


} # end module

regel.PositionKonfigurationModule = {

  start_value: () ->
    value = switch @auspraegung
      when regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
        4
      when regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
        1
    value

  end_value: () ->
    value = switch @auspraegung
      when regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
        1
      when regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
        4
    value
}

###
Das Konfigurationsmodell
###
class regel.Konfiguration extends Spine.Model
  @configure "Konfiguration", "id", "typ", "auspraegung", "gruenorangerot_position_100", "regel_id", "mitarbeiter_ids", "gruen_untere_grenze", "orange_untere_grenze", "rot_untere_grenze", "gruen_obere_grenze", "orange_obere_grenze", "rot_obere_grenze"
  @extend Spine.Model.Ajax
  @include regel.Module

  @MITARBEITER_ANZEIGEN = "mitarbeiter_anzeigen"
  @MITARBEITER_BEARBEITEN = "mitarbeiter_bearbeiten"

  @POSITION_KONFIGURATION = "POSITION"
  @GRUENORANGEROT_KONFIGURATION = "GRUENORANGEROT"

  @AUSPRAEGUNG_MAXIMIEREN = "maximieren"
  @AUSPRAEGUNG_MINIMIEREN = "minimieren"
  @AUSPRAEGUNG_EINSCHRAENKEN = "einschraenken"

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

    if @typ== regel.Konfiguration.POSITION_KONFIGURATION
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