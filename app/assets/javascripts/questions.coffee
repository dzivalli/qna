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
    $('.question-errors').html('')

  $('.list-group').on 'click', '.edit', (e) ->
    e.preventDefault()
    current_li = $(this).closest('li')
    current_li.hide()
    current_li.next('form').show()

  $('.list-group').on 'click', '#close', (e) ->
    e.preventDefault()
    current_form = $(this).closest('form')
    current_form.hide()
    current_form.prev('li').show()
    $(this).parents('.answer').children('.answer-errors').html('')

