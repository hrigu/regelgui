unless window.regel
  window.regel = {}

###
Das Regel-Modell.
###
class regel.Konfiguration extends Spine.Model
  type_as_string: () ->
    @constructor.name

#  moegliche_mitarbeiter: ->
#    #TODO regelgui: die Mitarbeiter welche in den anderen Konfigurationen auftauchen auch noch rausfiltern
#    regel.Mitarbeiter.all().filter((ma) => !@is_mitarbeiter_set(ma))

  mitarbeiter: ->
    @mitarbeiter_ids.map (id) -> regel.Mitarbeiter.find(id)


  add_mitarbeiter: (mitarbeiter) ->
    @mitarbeiter_ids.push mitarbeiter.id
    @save()

  remove_mitarbeiter: (mitarbeiter) ->
    index = @mitarbeiter_ids.indexOf mitarbeiter.id
    @mitarbeiter_ids.splice(index, 1)
    @save()

  is_mitarbeiter_set: (m) ->
    for id in @mitarbeiter_ids
      return true if m.id == id
    false

class regel.PositionKonfiguration extends regel.Konfiguration
  @configure "PositionKonfiguration", "id", "name", "gruenorangerot_position_100", "regel_id", "mitarbeiter_ids"
  @extend Spine.Model.Ajax

  @url: ->
    Routes.position_konfigurationen_path()

  url: (options)->
    Routes.position_konfiguration_path(@id)#"regel/#{@id}"