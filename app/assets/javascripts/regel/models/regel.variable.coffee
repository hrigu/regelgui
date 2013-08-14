unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Variable extends Spine.Model
  @configure "Variable", "id", "bedingung", "bezeichung"
  @extend Spine.Model.Ajax

  ###
  Unter dieser URL sind die Absenzen als JSON abholbar
  ###
  @url: ->
    Routes.regel_variablen_path()

  url: (options)->
    Routes.regel_variable_path(@id)
