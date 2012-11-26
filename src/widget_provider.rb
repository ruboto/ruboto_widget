require 'ruboto/base'
require 'ruboto/package'
require 'widget_configure'

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.os.SystemClock
import android.util.Log
import android.widget.RemoteViews

class WidgetProvider
  import org.ruboto.example.widget.R

  TAG = 'WidgetProvider'

  def onUpdate(context, appWidgetManager, appWidgetIds)
    Log.d(TAG, "onUpdate")
    appWidgetIds.each do |appWidgetId|
      titlePrefix = WidgetConfigure.loadTitlePref(context, appWidgetId)
      updateAppWidget(context, appWidgetManager, appWidgetId, titlePrefix)
    end
  end

  def onDeleted(context, appWidgetIds)
    Log.d(TAG, "onDeleted")
    appWidgetIds.each do |appWidgetId|
      WidgetConfigure.deleteTitlePref(context, appWidgetId)
    end
  end

  def onEnabled(context)
    Log.d(TAG, "onEnabled")
  end

  def onDisabled(context)
    Log.d(TAG, "onDisabled")
    PackageManager pm = context.getPackageManager()
  end

  def updateAppWidget(context, appWidgetManager, appWidgetId, titlePrefix)
    Log.d(TAG, "updateAppWidget appWidgetId=#{appWidgetId} titlePrefix=#{titlePrefix}")
    text = context.getString(R.string.widget_text_format, WidgetConfigure.loadTitlePref(context, appWidgetId))
    views = RemoteViews.new(context.getPackageName(), R.layout.widget)
    views.setTextViewText(Ruboto::Id.text, text)
    appWidgetManager.updateAppWidget(appWidgetId, views)
  end
end
