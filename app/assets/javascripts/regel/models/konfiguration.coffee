unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Konfiguration extends Spine.Model
  type_as_string: () ->
    @constructor.name

class regel.PositionKonfiguration extends regel.Konfiguration
  @configure "PositionKonfiguration", "id", "name", "gruenorangerot_position_100", "regel_id"
  @extend Spine.Model.Ajax

  @url: ->
    Routes.position_konfigurationen_path()

  url: (options)->
    Routes.position_konfiguration_path(@id)#"regel/#{@id}"

