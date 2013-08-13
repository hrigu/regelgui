unless window.regel
  window.regel = {}
#Namespace

###
  Controller für das modale Fenster zum erstellen einer neuen Konfiguration
  el = #neue-konfiguration-erstellen
###
class regel.NeueKonfigurationController extends Spine.Controller

  events:
    "click .btn-primary": "sichern"
    #"hidden #myModal": "fenster_schliessen"   #geht nicht, da #myModal kein Element dieser Konfiguration ist


  constructor: (options)->
    super(options)
    $("#myModal").on('hidden', @fenster_schliessen) #Diese Objekt releasen nachdem das modale Fenster versteckt wurde

  render: () ->
    html = JST['regel/views/neue_konfiguration']()
    @replace(html)
    @


  fenster_schliessen: () =>
    @release()


  sichern: ()->
    $("#myModal").modal("hide")