unless window.regel
  window.regel = {}
#Namespace

###
  Controller für das modale Fenster zum erstellen einer neuen Konfiguration
  el = #neue-konfiguration-erstellen
  @regel
###
class regel.NeueKonfigurationController extends Spine.Controller

  elements:
    "form": "formular"
  events:
    "click .btn-primary": "sichern"
    #"hidden #myModal": "fenster_schliessen"   #geht nicht, da #myModal kein Element dieser Konfiguration ist


  constructor: (options)->
    super(options)
    $("#myModal").on('hidden', @fenster_schliessen) #Diese Objekt releasen nachdem das modale Fenster versteckt wurde

  render: () ->
    html = JST['regel/views/neue_konfiguration']({
      regel: @regel
      # Die Optionen der Auswahl
      optionen: (konfigurations_varianten) ->
        html = ""
        index = 0
        for key, value of konfigurations_varianten
          checked = if index == 0 then true else false
          index += 1
          html += JST['regel/views/konfiguration_option']({varianten_name: key, variante: value, checked: checked})
        html
    })
    @replace(html)
    @


  fenster_schliessen: () =>
    @release()


  sichern: ()->
    value = @formular.find(":checked").attr("value")
    variante = regel.Konfiguration.KONFIGURATION_VARIANTEN[value]
    neue_konfiguration = switch
      when variante.konfiguration == regel.Konfiguration.POSITION_KONFIGURATION
        switch
          when variante.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
            new regel.Konfiguration(type: variante.konfiguration, auspraegung: regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN, regel_id: @regel.id, gruenorangerot_position_100: 10, mitarbeiter_ids: [])
          when variante.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
            new regel.Konfiguration(type: variante.konfiguration, auspraegung: regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN, regel_id: @regel.id, gruenorangerot_position_100: 10, mitarbeiter_ids: [])

      when variante.konfiguration == regel.Konfiguration.GRUENORANGEROT_KONFIGURATION
        switch
          when variante.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN
            new regel.Konfiguration(type: variante.konfiguration, auspraegung: regel.Konfiguration.AUSPRAEGUNG_MINIMIEREN, regel_id: @regel.id, gruen1: 10, orange1: 20, rot1: 30, mitarbeiter_ids: [])
          when variante.auspraegung == regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN
            new regel.Konfiguration(type: variante.konfiguration, auspraegung: regel.Konfiguration.AUSPRAEGUNG_MAXIMIEREN, regel_id: @regel.id, gruen2: 80, orange2: 50, rot2: 20, mitarbeiter_ids: [])
          when variante.auspraegung == regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN
            new regel.Konfiguration(type: variante.konfiguration, auspraegung: regel.Konfiguration.AUSPRAEGUNG_EINSCHRAENKEN, regel_id: @regel.id, gruen1: 30, orange1: 40, rot1: 50, gruen2: 30, orange2: 20, rot2: 10, mitarbeiter_ids: [])
    neue_konfiguration.save()
    $("#myModal").modal("hide")