# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  $('#skill_name').autocomplete
    appendTo: '.skill_name'
    source: '/skills/name_suggestions'
    minLength: 2
    select: (event, ui) ->
      $('#skill_name').val ui.item.value
      false
