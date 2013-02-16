String::extract_image_id = ->
  this.toString().split('_')[1]

String::get_image_path = ->
  this.toString().replace '?dl=1', ''

@cached = null

swap = =>
  if location.href.match /\/photo.php/

    if jQuery('img#fbPhotoImage').get(0)?
      # We're on the /photo.php page.
      # Let's just swap some sources
      img = jQuery('img#fbPhotoImage')
        
      # Fetch the original link from the Download button
      if (o_href = jQuery('a.fbPhotosPhotoActionsItem[rel="ignore"]').attr('href'))?
        # Swap the source
        img.attr 'src', o_href.get_image_path()

    if jQuery('#photos_snowlift').get(0)?
      # We're on cinema mode.
      img = jQuery('img.spotlight')
      if(@cached != img.attr('src').extract_image_id() and img.attr('src').extract_image_id()?)
        @cached = img.attr('src').extract_image_id()

        jQuery.get 'https://www.facebook.com/photo.php?fbid=' + img.attr('src').extract_image_id(), (data) ->
          if (o_href = jQuery(data).find('a.fbPhotosPhotoActionsItem[rel="ignore"]').attr('href'))?
            # Swap the source
            img.attr 'src', o_href.get_image_path()
    else
      # Clear cache
      @cached = null

window.setInterval swap, 500
