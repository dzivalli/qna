# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
init = ->
  $('body').on 'click', '.edit', (e) ->
    e.preventDefault()
    box = $(this).closest('.box')
    form = box.find('.form')
    url = form.data 'url'
    $.get url, (data) ->
      box.find('.body').hide()
      form.html(data)

  $('body').on 'click', '.button-close', (e) ->
    e.preventDefault()
    box = $(this).closest('.box')
    box.find('.body').show()
    box.find('form').hide()
    box.find('.errors').html('')

  $('body').on 'change', '.file_fields input:file', (e) ->
    all_buttons = $(this).closest('.box').find('.file_fields input:file')
    if this == all_buttons.last()[0]
      id = parseInt(all_buttons.last().attr('name').match(/\d+/)[0]) + 1
      obj = $(this).closest('form').attr('id').split('_')[1]
      name = "#{obj}[attachments_attributes][#{id}][file]"
      new_button = $("<input class='file_field' type='file' name=#{name}>")
      all_buttons.last().after(new_button)

  $('body').on 'click', '.delete-attachment', (e) ->
    e.preventDefault()
    id = $(this).data('destroy')
    $(this).parent('p').siblings("input[data-destroy=#{id}]").prop('checked', true)
    $(this).parent('p').remove()

$(document).ready init
$(document). on 'page:load', init