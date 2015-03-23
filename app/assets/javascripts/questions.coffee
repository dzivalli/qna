# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.question').on 'click', '.edit', (e) ->
    e.preventDefault()
    $('.panel-question').hide()
    $('.panel-form').show()

  $('.question').on 'click', '#close', (e) ->
    e.preventDefault()
    $('.panel-question').show()
    $('.panel-form').hide()

