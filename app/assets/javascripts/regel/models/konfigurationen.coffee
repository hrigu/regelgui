unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Regel extends Spine.Model
  @configure "Regel", "id", "name", "ist_aktiv", "variable_id"
  @extend Spine.Model.Ajax

  @url: ->
    "konfigurationen"

  url: (options)->
    "regel/#{@id}"


  status: ->
    if @ist_aktiv then "aktiv" else "inaktiv"


  status_change_msg: ->
    if @ist_aktiv then "deaktivieren" else "aktivieren"
