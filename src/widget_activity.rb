require 'ruboto/widget'

java_import android.content.pm.PackageManager
ruboto_import_widgets :LinearLayout, :TextView

class WidgetActivity
  def on_create(bundle)
    super
    set_title 'Ruboto Flashlight'
    flash_available = package_manager.hasSystemFeature(PackageManager::FEATURE_CAMERA_FLASH)

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => flash_available ? 'Place the Flashlight widget on your home screen.' : 'No flash available.',
                                 :id => 42, :width => :match_parent, :gravity => :center,
                                 :text_size => 48.0
        end
  rescue
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end
end
