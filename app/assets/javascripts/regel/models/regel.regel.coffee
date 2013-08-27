unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Regel extends Spine.Model
  @configure "Regel", "id", "sort_order", "sort_order_position", "name", "ist_aktiv", "variable_id", "zeitfenster", "grenze_maximum", "grenze_minimum"
  @extend Spine.Model.Ajax

  @url: ->
    Routes.regel_regeln_path()#"regeln"

  url: (options)->
    Routes.regel_regel_path(@id)#"regel/#{@id}"

  ###
  Alle Mitarbeiter, ob gesetzt oder nicht. (Fuer alle Regeln gleich)
  ###
  alle_mitarbeiter: ()->
    regel.Mitarbeiter.all()

  is_mitarbeiter_set: (m) ->
    for konfiguration in @konfigurationen()
      return true if konfiguration.is_mitarbeiter_set(m)
    false

  summe_aller_mitarbeiter:()->
    regel.Mitarbeiter.count()

  summe_der_gesetzten_mitarbeiter: ()->
    summe = 0
    for konfiguration in @konfigurationen()
      summe += konfiguration.mitarbeiter().length
    summe

  toggle_status: () ->
    @ist_aktiv = !@ist_aktiv
    @save()

  status: ->
    if @ist_aktiv then "aktiv" else "inaktiv"


  status_change_msg: ->
    if @ist_aktiv then "deaktivieren" else "aktivieren"


  moegliche_konfigurationsvarianten: ->
    konfigurationsvarianten = {}
    if @zeitfenster == null
      konfigurationsvarianten = regel.Konfiguration.KONFIGURATION_VARIANTEN
    else
      konfigurationsvarianten = {position_konfiguration_minimieren: regel.Konfiguration.KONFIGURATION_VARIANTEN.position_konfiguration_minimieren}
    konfigurationsvarianten



  konfigurationen: ->
    regel.Konfiguration.select((k) => k.regel_id == @id)
