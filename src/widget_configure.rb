puts 'load widget_configure'
require 'ruboto/widget'

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.os.Bundle
import android.view.View
import android.widget.EditText

import java.util.ArrayList

import org.ruboto.example.widget.R

ruboto_import_widgets :Button, :EditText, :LinearLayout, :TextView

puts 'class widget_configure'

class WidgetConfigure
  TAG = "WidgetConfigure"

  PREFS_NAME = "org.ruboto.example.widget.WidgetProvider"
  PREF_PREFIX_KEY = "prefix_"

  def on_create(bundle)
    puts 'WidgetConfigure#on_create'
    super
    set_title 'Ruboto Widget Configuration'
    @mAppWidgetId = AppWidgetManager::INVALID_APPWIDGET_ID
    setResult(RESULT_CANCELED)
    setContentView(R.layout.widget_configure)
    mAppWidgetPrefix = findViewById(R.id.appwidget_prefix)
    findViewById(R.id.save_button).setOnClickListener(proc{|v|configure(v)})
    intent = getIntent()
    Bundle extras = intent.getExtras()
    if (extras != nil)
        mAppWidgetId = extras.getInt(
                AppWidgetManager::EXTRA_APPWIDGET_ID, AppWidgetManager::INVALID_APPWIDGET_ID)
    end
    if (mAppWidgetId == AppWidgetManager::INVALID_APPWIDGET_ID)
        finish()
    end

    mAppWidgetPrefix.setText(loadTitlePref(self, mAppWidgetId))

    self.content_view =
        linear_layout :orientation => :vertical do
          @text_view = text_view :text => 'Configure me!', :id => 42, :width => :match_parent,
                                 :gravity => :center, :text_size => 48.0
          edit_text :id => 43, :width => :match_parent
          button :text => 'Save', :width => :match_parent, :id => 44, :on_click_listener => proc {|v| configure(v) }
        end
  rescue Exception
    puts "Exception creating activity: #{$!}"
    puts $!.backtrace.join("\n")
  end

  def configure(v)
    context = self
    titlePrefix = mAppWidgetPrefix.getText().toString()
    saveTitlePref(context, mAppWidgetId, titlePrefix)
    appWidgetManager = AppWidgetManager.getInstance(context)
    WidgetProvider.updateAppWidget(context, appWidgetManager, mAppWidgetId, titlePrefix)
    resultValue = Intent.new()
    resultValue.putExtra(AppWidgetManager::EXTRA_APPWIDGET_ID, mAppWidgetId)
    setResult(RESULT_OK, resultValue)
    finish()
  end

  def self.saveTitlePref(context, appWidgetId, text)
        prefs = context.getSharedPreferences(PREFS_NAME, 0).edit()
        prefs.putString(PREF_PREFIX_KEY + appWidgetId, text)
        prefs.commit()
  end

  def self.loadTitlePref(context, appWidgetId)
    prefs = context.getSharedPreferences(PREFS_NAME, 0)
    prefix = prefs.getString("#{PREF_PREFIX_KEY}#{appWidgetId}", nil)
    if (prefix != nil)
      return prefix
    else
      return "Hullo!"
    end
  end

  def self.deleteTitlePref(context, appWidgetId)
  end

  def self.loadAllTitlePrefs(context, appWidgetIds, texts)
  end
end

puts 'loaded widget_configure'
