#$(document).ready -> 
#  PreviewImage = ->
#    oFReader = new FileReader()
#    oFReader.readAsDataURL document.getElementById("book_photo").files[0]
#    oFReader.onload = (oFREvent) ->
#      document.getElementById("uploadPreviewbook").src = oFREvent.target.result
#    return
#    document.getElementById("book_photo").addEventListener "change", PreviewImage, false