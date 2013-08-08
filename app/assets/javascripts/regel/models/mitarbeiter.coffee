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
    Routes.mitarbeiter_index_path()

  url: (options)->
    Routes.mitarbeiter_path(@id )
