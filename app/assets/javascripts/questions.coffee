# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
init = ->
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

  $('.question').on 'change', '.file_fields input:file', (e) ->
    all_buttons = $('.file_fields input:file')
    if this == all_buttons.last()[0]
      id = parseInt(all_buttons.last().attr('name').match(/\d+/)[0]) + 1
      name = "question[attachments_attributes][" + id + "][file]"
      new_button = $("<input class='file_field' type='file' name=#{name}>")
      all_buttons.last().after(new_button)

  $('.question').on 'click', '.delete-attachment', (e) ->
    e.preventDefault()
    id = $(this).data('destroy')
    $(this).parent('p').siblings("input[data-destroy=#{id}]").prop('checked', true)
    $(this).parent('p').remove()


$(document).ready init
$(document). on 'page:load', init