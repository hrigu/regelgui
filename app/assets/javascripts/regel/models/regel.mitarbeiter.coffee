unless window.regel
  window.regel = {}

###
Das Mitarbeiter-Modell.
###
class regel.Mitarbeiter extends Spine.Model
  @configure "Mitarbeiter", "id", "kuerzel"
  @extend Spine.Model.Ajax

  ###
  Unter dieser URL sind die Absenzen als JSON abholbar
  ###
  @url: ->
    Routes.regel_mitarbeiter_index_path()

  url: (options)->
    Routes.regel_mitarbeiter_path(@id )
