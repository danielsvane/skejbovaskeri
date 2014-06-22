Reservations = new Meteor.Collection("reservations")
@Machines = new Meteor.Collection("machines")

pad = (time) ->
  if (time < 10) then "0"+time else time

if Meteor.isClient

  Template.reservations.machines = ->
    Machines.find()

  Template.reservations.reservation = ->
    Reservations.findOne
      machine: @.machine
      hour: @.hour

  Template.reservations.currentUsersReservation = ->
    @.user is Meteor.userId()

  Template.reservations.grid = ->
    grid = []
    
    for hour in [6..22]
      item = {}
      item.hour = pad(hour)+":00"
      item.reservations = []

      for machine in Machines.find().fetch()
        item.reservations.push
          machine: machine._id
          hour: hour

      grid.push item

    grid

  Template.reservations.events
    "click .reserve": ->
      Reservations.insert
        machine: @.machine
        hour: @.hour
        user: Meteor.userId()

    "click .clear-reservation": ->
      Reservations.remove @._id