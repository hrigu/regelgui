unless window.regel
  window.regel = {}

class regel.RegelAnzeigeAnzahlMitarbeiterController extends Spine.Controller

  ###
  regel
  ###
  constructor: (options)->
    super(options)
    regel.Status.bind("alle_daten_geladen", @zeige_mitarbeiter_infos)
    @regel.bind("anzahl_mitarbeiter_geaendert", @zeige_mitarbeiter_infos)

  zeige_mitarbeiter_infos: () =>
    html = JST['regel/views/regel_anzeige_anzahl_mitarbeiter'](@regel)
    @replace(html)
