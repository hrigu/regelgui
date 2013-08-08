unless window.regel
  window.regel = {}#Namespace


###
Convenience Klasse um das MVC Pattern aufzubauen und alle Objekte zu initialisieren
###
class regel.Builder

  ###
  Baut alles auf
  ###
  initialisieren: () ->
    new regel.RegelseiteController(el: "#regelseite").render()
    regel.Regel.fetch()
    regel.PositionKonfiguration.fetch()
    regel.Mitarbeiter.fetch()
#    gr.Variable.fetch()
#    gr.Mitarbeiter.fetch()
#    gr.MitarbeiterGruenorangerot.fetch()
