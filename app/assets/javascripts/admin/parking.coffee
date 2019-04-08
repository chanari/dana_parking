$(document).on 'click', '.btn-block', (e) ->
  e.preventDefault()
  rm_block =
    '<div class="form-group" style="margin-left: 20px;">
    <a href="javascript:void(0)" class="btn-rm-blocks">
    <i class="fas fa-trash"></i>
    </a>
    </div>'
  obj = $(this).closest('.form-floors').find('.form-blocks').eq(0).clone()
  obj.find('.row').eq(0).remove()
  obj.find('.form-inline').append rm_block
  clearInputs(obj)
  renameCloneIdsAndNames(obj, 'parking[floors_attributes]', 2)
  $(this).closest('fieldset.scheduler-border').find('.form-blocks').last().after obj
  return

$(document).on 'click', '.btn-reset', (e) ->
  e.preventDefault()
  $(this).closest('.form-floors').find('select.form-control').val ''
  $(this).closest('.form-floors').find('input.form-control').each ->
    $(this).val ''
    return
  return

$(document).on 'click', '.btn-rm-blocks', ->
  $(this).closest('.form-blocks').remove()
  return

$(document).on 'click', '.rm-floors', ->
  $(this).closest('.form-floors').remove()
  updateFloors('form-floors')
  return

$(document).ready ->
  $('#btn-floor').click (e) ->
    e.preventDefault()
    rm_floor = '<a href="javascript:void(0)" class="rm-floors"><i class="fas fa-minus-circle fa-lg"></i></a>'
    obj = $('.form-floors').eq(0).clone()
    obj.find('legend.scheduler-border').after rm_floor
    clearInputs(obj)
    obj.find('.form-blocks').not(':first').remove()
    renameCloneIdsAndNames(obj, 'parking[floors_attributes]', 1)
    $('.form-floors').last().after obj
    updateFloors('form-floors')
    return

  $('#selectPark').change ->
    $('#selectSlot').val('0')
    if $('#selectSlot').val() > 0
      loadingOverlay()
    return

  $('#selectSlot').change ->
    if $('#selectPark').val() > 0
      loadingOverlay()
    return

  return
